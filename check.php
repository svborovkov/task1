<?php 

$DB_SERVER = "localhost";
$DB_USER = "root";
$DB_PASSWORD = "password";
$DB_BASE = "Task1";

class Api_answerer{

    private $mysqli = null;
    private $user_name = "";
	private $user_id = null;
    private $test_id = null;
    private $question_id = "";
    private $answer_ids = "";
	private $stage = null;

//	input - 3 stages.
//	stage='index'. No other input data. Return json with test_list
//	stage='start_test'. Also input: user_name, test_id. Return error (if test is already completed,) or as stage='test_proceed'.
//	stage='proceed_test'. Also input: user_name, question_id, answers. Returns stage "test" or "result".

//	out - 3 stages:.
//	index - json contain test_list.
//	test - json contain: user_name, question_id, question_text, answers, question_count, answer_count
//	result - json contain user_name, question_count, correct_count


function connect_to_db(){
		global $DB_SERVER;
		global $DB_USER;
		global $DB_PASSWORD;
		global $DB_BASE;

        $m = new mysqli($DB_SERVER, $DB_USER, $DB_PASSWORD, $DB_BASE);
        if ($m->connect_error){
            return false;
        }
        $m->query('SET NAMES utf8');
        $this->mysqli=$m;
        return true;
    }

	function get_test_list(){
		$res=array();
		$result=$this->mysqli->query("SELECT DISTINCT test.id, test.name FROM test JOIN question ON question.test_id=test.id");
		while ($row=$result->fetch_assoc())
			$res[$row['id']]=$row['name'];
		return $res;
	}
	
	function fill_user_id(){
//	add user if it is'n exists		
		if (!isset($this->user_id)){
			$result=$this->mysqli->query("SELECT id FROM user WHERE name='{$this->user_name}'"); // 1 record max - unique index
			if ($row=$result->fetch_assoc())
				$this->user_id=$row['id'];
			else{
				$result=$this->mysqli->query("INSERT INTO `user`(`name`) VALUES ('{$this->user_name}')");
				$this->user_id=$this->mysqli->insert_id;
			}
		}
	}

	function save_answers(){
		if ($this->user_name=="" or $this->question_id=="" or $this->answers=="")
			throw new Exception("Couldn't connect to database");

		$answers_a=explode(',',$this->answers);
		$answers_a=array_filter($answers_a, 'is_numeric'); // injection ? 

		$this->fill_user_id();
		
		// save answers
		$result=$this->mysqli->query("
INSERT INTO `user_q_answer`(`q_answer_id`, `user_id`)
SELECT id, {$this->user_id} FROM `q_answer` WHERE question_id={$this->question_id} and id in (".implode(',', $answers_a).")");
		
	}
	
    function fill_input_params(){
		$stages = array('index', 'start_test', 'proceed_test');
		
		if (!isset($_POST['stage']) || array_search($_POST['stage'], $stages)===false)
			throw new Exception("Incorrect input data. No 'stage' param. Refresh the page please.");
		$this->stage=$_POST['stage'];
		
        $this->user_name = mysql_real_escape_string(isset($_POST['user_name']) ? $_POST['user_name'] : ""); // it is normal that it is not in base

        $this->test_id = isset($_POST['test_id']) ? $_POST['test_id'] : null;
        if (!is_numeric($this->test_id))
            $this->test_id=null;
		
        $this->question_id = isset($_POST['question_id']) ? $_POST['question_id'] : null;
        if (!is_numeric($this->question_id))
            $this->question_id=null;
	
        $this->answers = isset($_POST['answers']) ? $_POST['answers'] : ""; 
		
		if (isset($this->question_id) && !isset($this->test_id)){ // in stage "proceed_test" we don't receive test_id. Let's fill it from DB.
			$this->mysqli.query("SELECT question.test_id as test_id FROM question WHERE question.id=".$this->question_id);
			if ($row=$result->fetch_assoc())
				$this->test_id=$row['test_id'];
		}
    }

	function calc_and_save_results(){
		$answer=array('err_text'=>"");
		
		$this->fill_user_id(); // maybe it isn't filled if user gave all answers, but final result isn't in DB. This is incorrect data, but we should't raise an error
		
// request returns number of correct answers and questions. Compares by GROUP_CONCAT of answer_id
		$s="
SELECT SUM(IF(a.correct_answer=a.real_answer, 1, 0) ) as correct_answers, SUM(1) as questions
FROM 

(SELECT question.id as id, GROUP_CONCAT(DISTINCT q_answer.id ORDER BY q_answer.id) as correct_answer, GROUP_CONCAT(DISTINCT q_a2.id ORDER BY q_a2.id) as real_answer
FROM question
JOIN q_answer ON q_answer.question_id=question.id and q_answer.is_correct=1
JOIN q_answer as q_a2 ON q_a2.question_id=question.id 
JOIN user_q_answer ON user_id={$this->user_id} and user_q_answer.q_answer_id=q_a2.id

WHERE question.test_id={$this->test_id}
GROUP BY question.id) a";

		$result=$this->mysqli->query($s);
		$row=$result->fetch_assoc(); // whis request always return 1 row.
		$correct_count=$row['correct_answers'];
		$question_count=$row['questions'];
// saving results to DB
		$this->mysqli->query("
INSERT INTO `user_test_result`(`user_id`, `test_id`, `questions`, `correct_answers`)
VALUES ({$this->user_id},{$this->test_id},$question_count,$correct_count)");

// preparing answer
		$answer['stage']='result';
		$answer['correct_count']=$correct_count;
		$answer['question_count']=$question_count;
		$answer['user_name']=$this->user_name;
	
		return $answer;
	}
	
	function proceed_request(){

		$answer=array('err_text'=>"");

		try{
			if (!$this->connect_to_db())
				throw new Exception("Couldn't connect to database");
			
			$this->fill_input_params();
			
			if ($this->stage=='index'){
				$answer['test_list']=$this->get_test_list();
				$answer['stage']='index';
				return $answer;
			}

			if ($this->stage=='proceed_test')
				$this->save_answers();

			if ($this->user_name=='' || $this->test_id==null)
				throw new Exception("Incorrect input data. Refresh the page please.");
		
			$answer['user_name']=$this->user_name;
		
			// let's know - what is the next qeustion? What is the question count?
			$next_question_id=null;
			$next_question_text=null;
			$question_count=0;
			$answer_count=0;

// request question_id, is_answer_present, question_text. user_name might not saved in DB.
			$result=$this->mysqli->query(
"
	SELECT question.id as id, MAX(user_q_answer.user_id) as answer, question.text as text
	FROM question
	LEFT JOIN user ON user.name=\"{$this->user_name}\"
	JOIN q_answer ON question.id=q_answer.question_id
	LEFT JOIN user_q_answer on user_q_answer.q_answer_id=q_answer.id AND user.id=user_q_answer.user_id
	WHERE question.test_id={$this->test_id}
	GROUP BY question.id
	ORDER BY question.id");
			
			while ($row=$result->fetch_assoc()){
				$question_count++;
				if ($row['answer']!=null)
					$answer_count++;
				else if ($next_question_id==null){
					$next_question_id=$row['id'];
					$next_question_text=$row['text'];
				}
			}
// ok. Let's analyze results. 			
			if ($question_count==0){ // empty test??? This isn't correct.
				throw new Exception('incorrect input data');
			}else if ($question_count==$answer_count){
				// test is complete. we may be here two ways:
				// 1. Finally score is present. user tries to retest him. We should print an error.
				// 2. user ended test. So his finally score is not calculated.

// is there a final results of this test?
				$result=$this->mysqli->query(
"SELECT user.id
from user
join user_test_result ON user.id=user_test_result.user_id
where user.name='{$this->user_name}' AND user_test_result.test_id=".$this->test_id);
				if ($result->num_rows>0)
					throw new Exception("Test is already done.");
				else
					return $this->calc_and_save_results();
			}else{

			// next question is present. Let's show it.
//				print ("select id, text from q_answer where question_id=$next_question_id");
				$answer['question_count']=$question_count;
				$answer['answer_count']=$answer_count;
				$answer['question_text']=$next_question_text;
				$answer['question_id']=$next_question_id;
// getting answers for a question.
				$result=$this->mysqli->query("select id, text from q_answer where question_id=$next_question_id");
				$answs=array();
				while ($row=$result->fetch_assoc()){
					$answs[$row['id']]=$row['text'];
				}
				$answer['answers']=$answs;
				$answer['stage']='question';
				return $answer;
			}
		} catch (Exception $e){
			$answer['err_text']=$e->getMessage();
		}
			
		return $answer;
	}
}

$api_answerer = new Api_answerer;
$data=$api_answerer->proceed_request();
print(json_encode($data));

?>