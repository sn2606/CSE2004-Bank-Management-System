
select login_id, acc_balance from account_c where customer_id = 'C479';

select cheque_book_id from cheque_book where bank_acc_no = (select bank_acc_no from account_c where login_id = 2341);

select work_phone from employee_phone where employee_id = (select employee_id from account_c where bank_acc_no = 3122665055);

select recovery_email from customer_email where customer_id = (select customer_id from account_c where bank_acc_no = 5443772365);

select city from bank_branch where branch_id = (select branch_id from employee where employee_id = 'E175');

select b.bank_acc_no from account_c a, borrow_loan b where a.bank_acc_no = b.bank_acc_no;

select * from account_c a, make_transaction m, transaction_c t where (a.bank_acc_no = m.bank_acc_no) and (m.transaction_id = t.transaction_id) and t.transaction_amt > 300000;


alter table loan add loan_tenure number(3);
alter table loan add EMI number(15, 5);

SET SERVEROUTPUT ON;

declare
cursor c1 is select loan_id, interest_rate from loan;
lid loan.loan_id%type;
intr loan.interest_rate%type;
begin
open c1;
loop
fetch c1 into lid, intr;
exit when c1%notfound;
if intr < 3 then
update loan set loan_tenure = 3 where loan_id = lid;
dbms_output.put_line('Updated');
elsif (intr >= 3 and intr < 5) then
update loan set loan_tenure = 2 where loan_id = lid;
dbms_output.put_line('Updated');
else
update loan set loan_tenure = 1 where loan_id = lid;
dbms_output.put_line('Updated');
end if;
end loop;
close c1;
end;

select * from loan;


create or replace function Calculate_EMI(amt loan.loan_amount%type, intr loan.interest_rate%type, lte loan.loan_tenure%type)
return number is
emi loan.emi%type;
begin
emi := (amt * (intr / 100) * POWER((1 + (intr/100)), lte)) / (POWER((1 + (intr/100)), lte - 1));
return emi;
end;

declare
amt loan.loan_amount%type := 1000000; 
intr loan.interest_rate%type := 1; 
lte loan.loan_tenure%type := 3;
emi loan.emi%type;
begin
emi := Calculate_EMI(amt, intr, lte);
dbms_output.put_line(emi);
end;


create or replace function COUNT_CUSTOMERS(emp employee.employee_id%type)
return number is
cnt number(3);
begin
select count(*) into cnt from customer where employee_id = emp;
return cnt;
end;

declare 
emp employee.employee_id%type := 'E197';
cnt number(3);
begin
cnt := COUNT_CUSTOMERS(emp);
dbms_output.put_line(cnt);
end;


create or replace procedure TRANSACTION_TYPE(code transaction_c.transaction_type%type)
is
begin
if code = 1 then
dbms_output.put_line('Deposit');
elsif code = 2 then
dbms_output.put_line('Withdrawal');
elsif code = 3 then
dbms_output.put_line('Credit Card Payment');
elsif code = 4 then
dbms_output.put_line('Debit Card Payment');
elsif code = 5 then
dbms_output.put_line('Loan Repayment');
elsif code = 6 then
dbms_output.put_line('Cheque Received');
end if;
end;


declare
code transaction_c.transaction_type%type := 3;
begin
TRANSACTION_TYPE(code);
end;


select * from credit_card;

declare
cursor c2 is select credit_card_no, credit_card_expir from credit_card;
cno credit_card.credit_card_no%type;
cxp credit_card.credit_card_expir%type;
begin
open c2;
loop
fetch c2 into cno, cxp;
exit when c2%notfound;
if extract(year from sysdate) > extract(year from cxp) then
delete from credit_card where credit_card_no = cno;
end if;
end loop;
close c2;
end;

select * from credit_card;

select * from loan;

declare
cursor c3 is select loan_id, loan_amount, interest_rate, loan_tenure from loan;
lid loan.loan_id%type;
amt loan.loan_amount%type;
intr loan.interest_rate%type;
lte loan.loan_tenure%type;
begin
open c3;
loop
fetch c3 into lid, amt, intr, lte;
exit when c3%notfound;
update loan set emi = calculate_emi(amt, intr, lte) where loan_id = lid;
dbms_output.put_line('Updated');
end loop;
close c3;
end;

select * from loan;

create or replace trigger insert_emi_loan
before insert on loan
for each row
enable
begin
:new.emi := calculate_emi(:new.loan_amount, :new.interest_rate, :new.loan_tenure);
end;


insert into loan(loan_id, loan_amount, interest_rate, loan_tenure) values('6666', 123000, 2, 3);
insert into borrow_loan values('6666', 'C26', 5443772365);
select * from loan;

select * from transaction_c;


create or replace trigger update_account_c
after insert on make_transaction
for each row
enable
declare
tt transaction_c.transaction_type%type;
amt transaction_c.transaction_amt%type;
tid transaction_c.transaction_id%type;
begin
select transaction_type into tt from transaction_c where transaction_id = :new.transaction_id;
select transaction_amt into amt from transaction_c where transaction_id = :new.transaction_id;
select transaction_id into tid from transaction_c where transaction_id = :new.transaction_id;
if tt = 1 then
update account_c set acc_balance = acc_balance + amt where bank_acc_no = :new.bank_acc_no;
elsif tt = 2 then
update account_c set acc_balance = acc_balance - amt where bank_acc_no = :new.bank_acc_no;
end if;
end;


insert into transaction_c(transaction_id, transaction_type, transaction_amt) values(777777, 2, 1903);
insert into make_transaction values(777777, 'C452', 4866523119);
select * from account_c;


create table transferred(employee_id varchar2(11), old_branch_code number(3), new_branch_code number(3), constraint emp_id_fk_trad foreign key(employee_id) references employee(employee_id));

create or replace trigger transfer_employee
after insert on transferred
for each row
enable
declare
bid bank_branch.branch_id%type;
begin
select branch_id into bid from bank_branch where branch_code = :new.new_branch_code;
update employee set branch_id = bid where employee_id = :new.employee_id;
end;

insert into transferred values('E197', 1, 2);

select * from employee;


create or replace trigger customer_request
after insert on action
for each row
enable
declare
cnt number(4);
begin
select count(*) into cnt from request;
insert into request values(20 + cnt, :new.customer_id, :new.action_code);
end;

insert into action values(2, 'C479', 1, 0, 0, 0);
select * from request;


select * from transaction_c natural join make_transaction;
select sum(transaction_amt) from transaction_c natural join make_transaction group by customer_id having customer_id = 'C452';

select * from action;
select count(*) from action group by customer_id having customer_id = 'C479';


