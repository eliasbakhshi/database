use skolan;

CALL move_money('1111', '2222', 1.5);

CALL get_money('1111', @sum);
SELECT @sum;
