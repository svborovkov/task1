var question_id=-1;

$(document).ready(function(){
// fill test list	
	var data_s={'stage': 'index'};
		send_and_proceed(data_s);
	
// setting handlers.	
    $("#test_submit").click(function(event) {
		event.preventDefault();
        var err="";
        if ($("#user_name").val()=="")
            err="Please enter your name";
        else if ($("select").val()==null)
            err="Please choose a test";
        if (err!=""){
            alert(err);
            return false;
        }else{
			var data_s={'stage': 'start_test', 'user_name': $("#user_name").val(), 'test_id': $("select").val()};
			send_and_proceed(data_s);

        }
    });
	
    $("#answer_submit").click(function(event) {
		event.preventDefault();
        var err="";
		if ($('.answer.active').length==0){
            alert('No selected answers found');
        }else{
			actives=$('.answer.active').toArray();
			active_ids=[];
			for(var act in actives){
				active_ids.push(actives[act].getAttribute('value'));
			}
			var data_s={'stage': 'proceed_test', 'user_name': $("#user_name").val(), 'answers': active_ids.join(','), 'test_id': $("select").val(), 'question_id': window.question_id}
			send_and_proceed(data_s);

        }
    })
});
        
function send_and_proceed(data_to_send){
	var $form = $("form");
	var $inputs = $form.find("input, select, button, textarea");
//	$inputs.prop("disabled", true);
	request = $.ajax({
		url: "check.php",
		type: "post",
		data: data_to_send
	});
		// Callback handler that will be called on success
	request.done(function (response, textStatus, jqXHR){
		// Log the response to the console
		console.log("Response: "+response);

		j_res=JSON.parse(response);
		proceed_json(j_res);
	});

	// Callback handler that will be called on failure
	request.fail(function (jqXHR, textStatus, errorThrown){
		console.error("The following error occurred: "+ textStatus, errorThrown);
	});

	// Callback handler that will be called regardless
	// if the request failed or succeeded
	request.always(function () {
		// Reenable the inputs
//		$inputs.prop("disabled", false);
	});
}	

function proceed_json(j_res){
	if (j_res["err_text"]!=""){
		alert(j_res["err_text"]);
		return false;
	}

	var stages = ['index', 'question', 'result'];
//	warning! These values are used in html file!
	
	if (stages.indexOf(j_res["stage"])<0){
		alert('Incorrect server answer.');
		return false;
	}
	var stage=j_res["stage"];

//	show stage part of html	
	$("."+stage).siblings().hide();
	$("."+stage).show();


// just import to html all info.
	
	if (stage=='index'){
		$(".test_list").empty();
		$(".test_list").append('<option selected="" disabled="">Choose test</option>');
		for (var id in j_res["test_list"]){
			$(".test_list").append('<option value="'+id+'">'+j_res["test_list"][id]+'</option>');
		}
	}else if (stage=='question'){
		$(".question_count").text(j_res["question_count"]);
		$(".answer_count").text(j_res["answer_count"]+1);
		$("#question_text").text(j_res["question_text"]);
		window.question_id=j_res["question_id"]; // store to send answers
		$(".progressbar").empty();
		$(".progressbar").append('<progress max="'+j_res["question_count"]+'" value="'+(j_res["answer_count"]+1)+'">');

// fill answers		
		$("#answers").empty();
		for (var id in j_res["answers"]){
			$("#answers").append('<article value="'+id+'" class="col answer">'+j_res["answers"][id]+'</article>');
		}
		
		$(".col").click(function(){
			$(this).toggleClass("active");
			return false;
		});
	}else if (stage=='result'){
		$(".question_count").text(j_res["question_count"]);
		$(".correct_count").text(j_res["correct_count"]);
		$(".user_name").text(j_res["user_name"]);
	}
}