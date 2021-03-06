CREATE TABLE day01 (rownum serial, input text);

\COPY day01 (input) FROM 'input.txt'

SELECT coalesce(sum(digit::integer) FILTER (WHERE digit = next_digit), 0) AS first_star
FROM (
    SELECT u.digit,
           coalesce(lead(u.digit) OVER w, first_value(u.digit) OVER w) AS next_digit
    FROM day01 AS d,
         unnest(string_to_array(d.input, null)) WITH ORDINALITY AS u (digit, ordinality)
    WINDOW w AS (ORDER BY u.ordinality)
) _;

SELECT coalesce(sum(digit::integer) FILTER (WHERE ordinality <= length(input) AND digit = next_digit), 0) AS second_star
FROM (
    SELECT d.input,
           u.digit,
           u.ordinality,
           coalesce(lead(u.digit, length(d.input)/2) OVER (ORDER BY u.ordinality)) AS next_digit
    FROM day01 AS d,
         unnest(string_to_array(d.input || d.input, null)) WITH ORDINALITY AS u (digit, ordinality)
) _;

DROP TABLE day01;
