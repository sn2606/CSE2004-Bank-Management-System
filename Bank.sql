create table customer(pan_card varchar2(10), aadhar_card number(12), customer_name varchar2(20), gender varchar2(2), dob date, age number(3), address varchar2(30), employee_id varchar2(11), customer_id varchar2(12),
constraint pan_pk primary key(pan_card), constraint c_id_unique unique(customer_id), constraint chk_gender_cons check(gender in ('F', 'M', 'T')), constraint age check(age >= 18));

create table employee(employee_id varchar2(11), emp_name varchar2(20), dob date, address varchar2(30), age number(3), gender varchar2(2), start_date date, branch_id varchar2(8), 
constraint emp_id_pk primary key(employee_id), constraint chk_gender_emp_cons check(gender in ('F', 'M', 'T')), constraint start_date check(start_date > '01-JAN-2001')); 


create table bank_branch(branch_id varchar2(8), city varchar2(20), state varchar2(20), branch_code number(2), manager_id varchar2(11),
constraint branch_id_pk primary key(branch_id), constraint b_code_chk check(branch_code between 1 and 7), constraint m_id_fk foreign key(manager_id) references employee(employee_id));

create table account_c(bank_acc_no number(11), customer_id varchar2(12), employee_id varchar2(11), branch_id varchar2(8), login_id varchar2(14), acc_crea_time timestamp, bank_acc_type varchar2(20), acc_balance number(10, 5),
constraint acc_no_pk primary key(bank_acc_no), constraint cust_id_fk foreign key(customer_id) references customer(customer_id), constraint emp_id_fk_acc foreign key(employee_id) REFERENCES employee(employee_id),
constraint brc_id_fk_acc foreign key(branch_id) references bank_branch(branch_id), constraint lod_id_unq unique(login_id), constraint acc_crea_time_chk check(acc_crea_time > '01-01-2001'));

alter table account_c add constraint acc_type_chk check(bank_acc_type in ('Current', 'Savings'));

create table credit_card(credit_card_no number(12), customer_id varchar2(12), credit_limit number(10, 5), credit_card_expir date not null, bank_acc_no number(11), 
constraint cust_id_cc_fk foreign key(customer_id) references customer(customer_id));

alter table credit_card add constraint acc_no_fk_cc foreign key(bank_acc_no) references account_c(bank_acc_no);

create table debit_card(debit_card_no number(12), customer_id varchar2(12), debit_limit number(10, 5), debit_card_expir date not null, bank_acc_no number(11), 
constraint cust_id_dc_fk foreign key(customer_id) references customer(customer_id), constraint acc_no_fk_dc foreign key(bank_acc_no) references account_c(bank_acc_no));

alter table credit_card add constraint cc_pk primary key(credit_card_no);
alter table debit_card add constraint dc_pk primary key(debit_card_no);

create table cheque_book( bank_acc_no number(11), cheque_book_id varchar2(14), customer_id varchar2(12), amount_limit number(10, 5), cheques_allowed number(3) not null, cheques_used number(3), 
constraint cb_pk primary key(cheque_book_id), constraint cust_id_cb_fk foreign key(customer_id) references customer(customer_id), constraint acc_no_fk_cb foreign key(bank_acc_no) references account_c(bank_acc_no));

create table transaction_c(transaction_id number(14), completion_time timestamp, transaction_type number(2), purpose varchar2(40), transaction_amt number(7,5), receiving_acc number(11),
constraint tran_id_pk primary key(transaction_id), constraint tran_type_chk check(transaction_type between 1 and 10), constraint rec_acc_fk foreign key(receiving_acc) references account_c(bank_acc_no));

create table loan(loan_id varchar2(11), loan_amount number(10,3), interest_rate number(2,2), constraint loan_id_pk primary key(loan_id), constraint loan_amt_chk check(loan_amount between 0 and 1000000000),
constraint int_rat_chk check(interest_rate < 10));

create table action(action_code number(2), customer_id varchar2(12), acc_mini_stmt number(2), stop_cheque number(2), updation number(2), view_loans number(2), constraint act_code_chk check(action_code in (1, 2, 3, 4)),
constraint cust_id_fk_act foreign key(customer_id) references customer(customer_id), constraint acc_stmt_chk check(acc_mini_stmt in (0, 1)), constraint stop_chq_chk check(stop_cheque in (0, 1)), 
constraint upd_chk check(updation in (0, 1)), constraint view_loans_chk check(view_loans in (0, 1)));


create table request(request_id varchar2(8), customer_id varchar2(12), action_code number(2), constraint re_id_pk primary key(request_id), constraint cust_id_req_fk foreign key(customer_id) references customer(customer_id),
constraint act_code_chk_req check(action_code in (1, 2, 3, 4)));

create table customer_email(customer_id varchar2(12), primary_email varchar2(30), recovery_email varchar2(30), constraint cust_id_fk_email foreign key(customer_id) references customer(customer_id));
create table customer_phone(customer_id varchar2(12), primary_phone varchar2(30), recovery_phone varchar2(30), constraint cust_id_fk_phone foreign key(customer_id) references customer(customer_id));
create table employee_email(employee_id varchar2(11), personal_email varchar2(30), work_email varchar2(30), constraint emp_id_fk_email foreign key(employee_id) references employee(employee_id));
create table employee_phone(employee_id varchar2(11), personal_phone varchar2(30), work_phone varchar2(30), constraint emp_id_fk_phone foreign key(employee_id) references employee(employee_id));


create table borrow_loan(loan_id varchar2(11), customer_id varchar2(12), bank_acc_no number(11), constraint loan_id_fk foreign key(loan_id) references loan(loan_id), 
constraint bor_loan_cust_fk foreign key(customer_id) references customer(customer_id), constraint bor_loan_acc_fk foreign key(bank_acc_no) references account_c(bank_acc_no));

create table make_transaction(transaction_id number(14), customer_id varchar2(12), bank_acc_no number(11), constraint tran_id_fk foreign key(transaction_id) references transaction_c(transaction_id),
constraint make_tran_cust_fk foreign key(customer_id) references customer(customer_id), constraint make_tran_acc_fk foreign key(bank_acc_no) references account_c(bank_acc_no));



insert into customer values ('CFKTP1279F', 437851623124, 'TARA', 'F', '20-SEPTEMBER-1985', 35, '4,HYDERABAD', 'E112', 'C451');
insert into customer values ('BLOFA3541C', 743900242407, 'MORGAN', 'M', '12-FEBRUARY-1980', 40, '7,GURGAON', 'E134', 'C479');
insert into customer values ('JDELV1659I', 614855251324, 'AARON', 'M', '21-AUGUST-1989', 31, '9,MUMBAI', 'E175', 'C26');
insert into customer values ('TROSB3764K', 544331021104, 'SASHA', 'F', '01-JANUARY-1982', 38, '6,CHENNAI', 'E148', 'C407');
insert into customer values ('PTVAE6349R', 377414388235, 'BETH', 'F', '25-JUNE-1994', 26, '8,BANGALORE', 'E165', 'C466');
insert into customer values ('SATUR9217B', 474924062408, 'LORI', 'F', '26-AUGUST-1996', 24, '2,GOA', 'E197', 'C452');

insert into employee values ('E112', 'RICK', '20-APRIL-1983', '7,WARANGAL', 37, 'M', '12-MAY-2004', 'B428');
insert into employee values ('E134', 'GLENN', '25-MARCH-1986', '3,VELLORE', 34, 'M', '20-APRIL-2005', 'B537');
insert into employee values ('E175', 'MAGGIE', '12-JANUARY-1985', '1,OOTY', 35, 'F', '07-SEPTEMBER-2006', 'B768');
insert into employee values ('E148', 'CAROL', '06-JUNE-1987', '4,SIDDIPET', 33, 'F', '13-FEBRUARY-2007', 'B344');
insert into employee values ('E165', 'CARL','16-SEPTEMBER-1981', '5,JAIPUR', 39, 'M', '18-DECEMBER-2008', 'B814');
insert into employee values ('E197', 'DARYL', '19-AUGUST-1989', '7,AGRA', 31, 'M', '24-AUGUST-2009', 'B454');

insert into bank_branch values ('B428', 'CHENNAI', 'TAMIL NADU', 3, 'E112');
insert into bank_branch values ('B537', 'MUMBAI', 'MAHARASHTRA', 4, 'E134');
insert into bank_branch values ('B768', 'HYDERABAD', 'TELANGANA', 5, 'E175');
insert into bank_branch values ('B344', 'BENGALURU', 'KARNATAKA', 2, 'E148');
insert into bank_branch values ('B814', 'JAIPUR', 'RAJASTHAN', 6, 'E165');
insert into bank_branch values ('B454', 'KOCHI', 'KERALA', 1, 'E197');

alter table account_c drop constraint acc_crea_time_chk;

insert into account_c values (6734543221, 'C452', 'E112', 'B428', 2341, '04-05-2006', 'Current', 10000.00);
insert into account_c values (1384321668, 'C479', 'E134', 'B537', 4422, '16-06-2008', 'Current', 20000.00);
insert into account_c values (5443772365, 'C26', 'E175', 'B768', 3453, '16-09-2018', 'Savings', 30000.00);
insert into account_c values (3122665055, 'C407', 'E148', 'B344', 7105, '21-03-2007', 'Current', 40000.00);
insert into account_c values (7749965201, 'C466', 'E165', 'B814', 2107, '12-05-2017', 'Savings', 50000.00);
insert into account_c values (4866523119, 'C452', 'E197', 'B454', 6688, '19-10-2012', 'Savings', 60000.00);

insert into credit_card values (12345678, 'C452', 10000, '01-JAN-2025', 6734543221);
insert into credit_card values (21053422, 'C479', 20000.00, '01-MAR-2025', 1384321668);
insert into credit_card values (43207512, 'C26', 30000.00, '01-APR-2025', 5443772365);
insert into credit_card values (65179110, 'C407', 40000.00, '01-MAY-2025', 3122665055);
insert into credit_card values (52004499, 'C466', 50000.00, '01-JUN-2025', 7749965201);
insert into credit_card values (74035637, 'C452', 60000.00, '01-JUL-2025', 4866523119);

insert into debit_card values (54322104, 'C452', 20000.00, '01-JANUARY-2026', 6734543221);
insert into debit_card values (37684502, 'C479', 30000.00, '01-MARCH-2026', 1384321668);
insert into debit_card values (99733558, 'C26', 40000.00, '01-APRIL-2026', 5443772365);
insert into debit_card values (12122002, 'C407', 50000.00, '01-MAY-2026', 3122665055);
insert into debit_card values (66882211, 'C466', 60000.00, '01-JUNE-2026', 7749965201);
insert into debit_card values (49977392, 'C452', 70000.00, '01-JULY-2026', 4866523119);

insert into cheque_book values (6734543221, 74321, 'C452', 40000.000, 15, 10);
insert into cheque_book values (1384321668, 53466, 'C479', 50000.000, 16, 11);
insert into cheque_book values (5443772365, 33981, 'C26', 60000.000, 17, 12);
insert into cheque_book values (3122665055, 27468, 'C407', 70000.000, 18, 13);
insert into cheque_book values (7749965201, 97553, 'C466', 80000.000, 19, 14);
insert into cheque_book values (4866523119, 88664, 'C452', 90000.000, 20, 15);

alter table transaction_c modify transaction_amt number(20);
alter table transaction_c drop constraint rec_acc_fk;


insert into transaction_c values (123456, '01-JAN-2020 4:00:10', 1, 'PC',  100000, 4486531279);
insert into transaction_c values (234792, '02-MAR-2020 5:10:20', 2, 'PHONE ', 200000, 5413724397);
insert into transaction_c values (867326, '03-APR-2020 6:20:30', 3, ' LAPTOP LOAN', 300000, 3664131287);
insert into transaction_c values (435179, '04-MAY-2020 7:30:40', 4, 'BIKE LOAN', 400000, 7729948634);
insert into transaction_c values (399728, '05-JUN-2020 8:40:50', 5, 'CAR LOAN', 500000, 9978655213);
insert into transaction_c values (937754, '06-JUL-2020 9:50:55', 6,  'HOUSE LOAN', 600000, 1123345567);

alter table loan modify loan_amount number(20);
alter table loan modify interest_rate number(3);


insert into loan values (3324, 1000000, 1);
insert into loan values (2648, 2000000, 2);
insert into loan values (1237, 3000000, 3);
insert into loan values (9556, 4000000, 4);
insert into loan values (6351, 5000000, 5);
insert into loan values (8265, 6000000, 6);

insert into action values (1, 'C451', 1, 0, 0, 1);
insert into action values (2, 'C479', 1, 0, 0, 1);
insert into action values (3, 'C26', 0, 1, 1, 0);
insert into action values (4, 'C407', 0, 1, 1, 0);
insert into action values (2, 'C466', 1, 0, 0, 1);
insert into action values (4, 'C452', 1, 0, 0, 1);

insert into request values (11, 'C451', 1);
insert into request values (12, 'C479', 2);
insert into request values (13, 'C26', 3);
insert into request values (14, 'C407', 4);
insert into request values (15, 'C466', 3);
insert into request values (16, 'C452', 3);

insert into customer_email values ('C451', 'tara@gmail.com', 'tara@yahoo.com');
insert into customer_email values ('C479', 'morgan@gmail.com', 'morgan@yahoo.com');
insert into customer_email values ('C26', 'aaron@gmail.com', 'aaron@yahoo.com');
insert into customer_email values ('C407', 'sasha@gmail.com', 'sasha@yahoo.com');
insert into customer_email values ('C466', 'beth@gmail.com', 'beth@yahoo.com');
insert into customer_email values ('C452', 'lori@gmail.com', 'lori@yahoo.com');

insert into customer_phone values ('C451', 9988667710, 9988667720);
insert into customer_phone values ('C479', 9988667711, 9988667721);
insert into customer_phone values ('C26', 9988667712, 9988667722);
insert into customer_phone values ('C407', 9988667713, 9988667733);
insert into customer_phone values ('C466', 9988667714, 9988667744);
insert into customer_phone values ('C452', 9988667715, 9988667755);

insert into employee_email values ('E112', 'rick@gmail.com', 'rick@yahoo.com');
insert into employee_email values ('E134', 'glenn@gmail.com', 'glenn@yahoo.com');
insert into employee_email values ('E175', 'maggie@gmail.com', 'maggie@yahoo.com');
insert into employee_email values ('E148', 'carol@gmail.com', 'carol@yahoo.com');
insert into employee_email values ('E165', 'carl@gmail.com', 'carl@yahoo.com');
insert into employee_email values ('E197', 'daryl@gmail.com', 'daryl@yahoo.com');

insert into employee_phone values ('E112', 8988667710, 8988667720);
insert into employee_phone values ('E134', 8988667711, 8988667721);
insert into employee_phone values ('E175', 8988667712, 8988667722);
insert into employee_phone values ('E148', 8988667713, 8988667733);
insert into employee_phone values ('E165', 8988667714, 8988667744);
insert into employee_phone values ('E197', 8988667715, 8988667755);

insert into borrow_loan values (3324, 'C451', 6734543221);
insert into borrow_loan values (2648, 'C479', 1384321668);
insert into borrow_loan values (1237, 'C26', 5443772365);
insert into borrow_loan values (9556, 'C407', 3122665055);
insert into borrow_loan values (6351, 'C466', 7749965201);
insert into borrow_loan values (8265, 'C452', 4866523119);

insert into make_transaction values (123456, 'C451', 6734543221);
insert into make_transaction values (234792, 'C479', 1384321668);
insert into make_transaction values (867326, 'C26', 5443772365);
insert into make_transaction values (435179, 'C407', 3122665055);
insert into make_transaction values (399728, 'C466', 7749965201);
insert into make_transaction values (937754, 'C452', 4866523119);



select * from customer;
select * from employee;
select * from account_c;
select * from credit_card;
select * from debit_card;
select * from cheque_book;
select * from transaction_c;
select * from loan;
select * from action;
select * from request;
select * from customer_email;
select * from customer_phone;
select * from employee_email;
select * from employee_phone;
select * from borrow_loan;
select * from make_transaction;

