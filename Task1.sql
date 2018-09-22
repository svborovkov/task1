-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u2
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Сен 22 2018 г., 16:19
-- Версия сервера: 5.5.57-0+deb8u1
-- Версия PHP: 5.6.30-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `Task1`
--

-- --------------------------------------------------------

--
-- Структура таблицы `question`
--

CREATE TABLE IF NOT EXISTS `question` (
`id` int(11) NOT NULL,
  `text` text COLLATE utf8_bin NOT NULL,
  `test_id` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Дамп данных таблицы `question`
--

INSERT INTO `question` (`id`, `text`, `test_id`) VALUES
(3, 'What colour is like red?', 2),
(4, 'What color if darker then silver?', 2),
(9, '2+2=?', 6),
(10, '2+3=?', 6),
(11, '2*5< ?', 6);

-- --------------------------------------------------------

--
-- Структура таблицы `q_answer`
--

CREATE TABLE IF NOT EXISTS `q_answer` (
`id` int(11) NOT NULL,
  `text` text COLLATE utf8_bin NOT NULL,
  `question_id` int(11) NOT NULL,
  `is_correct` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Дамп данных таблицы `q_answer`
--

INSERT INTO `q_answer` (`id`, `text`, `question_id`, `is_correct`) VALUES
(1, 'Gray', 3, 0),
(2, 'Blue', 3, 0),
(3, 'White', 3, 0),
(4, 'Black', 3, 0),
(5, 'Orange', 3, 1),
(6, 'Black', 4, 1),
(7, 'White', 4, 0),
(8, 'gray', 4, 1),
(9, '2', 9, 0),
(10, '3', 9, 0),
(11, '4', 9, 1),
(12, '5', 9, 0),
(13, '6', 9, 0),
(14, '3', 10, 0),
(15, '4', 10, 0),
(16, '5', 10, 1),
(17, '6', 10, 0),
(18, '8', 10, 0),
(24, '8', 11, 0),
(25, '9', 11, 0),
(26, '10', 11, 0),
(27, '12', 11, 1),
(28, '130', 11, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `test`
--

CREATE TABLE IF NOT EXISTS `test` (
`id` int(11) NOT NULL,
  `name` varchar(200) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Дамп данных таблицы `test`
--

INSERT INTO `test` (`id`, `name`) VALUES
(2, 'Colors'),
(3, 'Materials (empty)'),
(6, 'Mathematics');

-- --------------------------------------------------------

--
-- Структура таблицы `user`
--

CREATE TABLE IF NOT EXISTS `user` (
`id` int(11) NOT NULL,
  `name` varchar(200) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Дамп данных таблицы `user`
--

INSERT INTO `user` (`id`, `name`) VALUES
(2, '1123'),
(31, '121'),
(18, '3da'),
(20, 'aaa'),
(14, 'adg'),
(13, 'asa'),
(7, 'asas'),
(28, 'asxz'),
(26, 'ffff'),
(30, 'kjshlkj'),
(17, 'q1w2'),
(15, 'qaz'),
(16, 'qaz1'),
(21, 'qwe'),
(29, 'sdfsdfsdfsd'),
(33, 'sdsd'),
(6, 'sss'),
(1, 'svb'),
(27, 'wer'),
(25, 'www'),
(23, 'xcvxcv'),
(22, 'xxx'),
(19, 'zx'),
(24, 'zzaa'),
(9, '{this->user_name}'),
(32, 'аааа');

-- --------------------------------------------------------

--
-- Структура таблицы `user_q_answer`
--

CREATE TABLE IF NOT EXISTS `user_q_answer` (
  `q_answer_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Дамп данных таблицы `user_q_answer`
--

INSERT INTO `user_q_answer` (`q_answer_id`, `user_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(5, 1),
(8, 1),
(1, 15),
(3, 15),
(5, 15),
(6, 15),
(8, 15),
(5, 16),
(7, 16),
(5, 17),
(7, 17),
(3, 18),
(4, 18),
(6, 18),
(8, 18),
(5, 19),
(7, 19),
(5, 20),
(8, 20),
(5, 21),
(6, 21),
(5, 22),
(7, 22),
(5, 23),
(7, 23),
(5, 24),
(7, 24),
(5, 25),
(6, 25),
(7, 25),
(8, 25),
(5, 26),
(5, 27),
(7, 27),
(8, 27),
(11, 27),
(16, 27),
(27, 27),
(28, 27),
(1, 28),
(5, 28),
(6, 28),
(3, 29),
(5, 30),
(6, 30),
(8, 30),
(5, 31),
(7, 31),
(5, 32),
(8, 32),
(4, 33),
(6, 33),
(8, 33);

-- --------------------------------------------------------

--
-- Структура таблицы `user_test_result`
--

CREATE TABLE IF NOT EXISTS `user_test_result` (
`id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `test_id` int(11) NOT NULL,
  `questions` int(11) NOT NULL,
  `correct_answers` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Дамп данных таблицы `user_test_result`
--

INSERT INTO `user_test_result` (`id`, `user_id`, `test_id`, `questions`, `correct_answers`) VALUES
(1, 2, 3, 2, 1),
(2, 20, 2, 2, 1),
(3, 21, 2, 2, 1),
(4, 22, 2, 2, 1),
(5, 23, 2, 2, 1),
(6, 24, 2, 2, 1),
(7, 25, 2, 2, 1),
(8, 27, 2, 2, 1),
(9, 28, 2, 2, 0),
(10, 30, 2, 2, 2),
(11, 1, 2, 2, 0),
(12, 31, 2, 2, 1),
(13, 32, 2, 2, 1),
(14, 33, 2, 2, 1),
(15, 27, 6, 3, 3);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `question`
--
ALTER TABLE `question`
 ADD PRIMARY KEY (`id`), ADD KEY `test_id` (`test_id`);

--
-- Индексы таблицы `q_answer`
--
ALTER TABLE `q_answer`
 ADD PRIMARY KEY (`id`), ADD KEY `question_id` (`question_id`);

--
-- Индексы таблицы `test`
--
ALTER TABLE `test`
 ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `user`
--
ALTER TABLE `user`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `user_q_answer`
--
ALTER TABLE `user_q_answer`
 ADD PRIMARY KEY (`q_answer_id`,`user_id`), ADD KEY `user_id` (`user_id`), ADD KEY `q_answer_id` (`q_answer_id`,`user_id`);

--
-- Индексы таблицы `user_test_result`
--
ALTER TABLE `user_test_result`
 ADD PRIMARY KEY (`id`), ADD KEY `user_id` (`user_id`), ADD KEY `test_id` (`test_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `question`
--
ALTER TABLE `question`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT для таблицы `q_answer`
--
ALTER TABLE `q_answer`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=29;
--
-- AUTO_INCREMENT для таблицы `test`
--
ALTER TABLE `test`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT для таблицы `user`
--
ALTER TABLE `user`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=34;
--
-- AUTO_INCREMENT для таблицы `user_test_result`
--
ALTER TABLE `user_test_result`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `question`
--
ALTER TABLE `question`
ADD CONSTRAINT `question_ibfk_1` FOREIGN KEY (`test_id`) REFERENCES `test` (`id`);

--
-- Ограничения внешнего ключа таблицы `q_answer`
--
ALTER TABLE `q_answer`
ADD CONSTRAINT `q_answer_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`);

--
-- Ограничения внешнего ключа таблицы `user_q_answer`
--
ALTER TABLE `user_q_answer`
ADD CONSTRAINT `user_q_answer_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
ADD CONSTRAINT `user_q_answer_ibfk_1` FOREIGN KEY (`q_answer_id`) REFERENCES `q_answer` (`id`);

--
-- Ограничения внешнего ключа таблицы `user_test_result`
--
ALTER TABLE `user_test_result`
ADD CONSTRAINT `user_test_result_ibfk_2` FOREIGN KEY (`test_id`) REFERENCES `test` (`id`),
ADD CONSTRAINT `user_test_result_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
