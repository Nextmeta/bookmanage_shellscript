#######################################################################
# file name: bookmanage.sh
# author   : Yu Liu
# email    : <ilhanwnz@hotmail.com>
# time     : Tue 22 Jan 2019 10:41:33 PM CST
#######################################################################

user_name="";
user_passwd="";
istrue=0;

usr_login() 
{
	while [ $istrue == 0 ]
	do
		echo -e "Welcome my book management system!";
		echo -n "Enter your user name: ";
		read user_name;
		echo -n "Enter your password: ";
		read user_passwd;
		check_name_pwd;
		istrue=$?;
		
	done
}
check_name_pwd()
{
	# Just test code, please don't programming like this in real world
	# You should use some encrypt algorithm to prevent reverse cracking.
	# Such as, use uniform hash function. 

	if [ $user_name == "hanwnz" ] && [ $user_passwd == "znwnahli1314" ]
	then 
		echo_interface;
		return 1;
	else
		echo_error;
		return 0;
	fi
}

echo_interface()
{
	while [ $istrue == 0 ] 
	do
		echo -e "\n";
		echo -e "1. Add books";
		echo -e "2. Find books";
		echo -e "3. Delete books";
		echo -e "4. Update books";
		echo -e "5. Exit system";
		echo -n "Which item do you want to choice(1-4): ";
		read choice;
		case "$choice" in
			1) add_books;;
			2) find_books;;
			3) delete_books;;
			4) update_books;;
			5) istrue=1;;
			*) echo_choice_error;;
		esac
	done 
}

add_books()
{
	echo -e "Which book do you want to adding?";
	echo -n "Book Name: ";
	read book_name;
	echo -n "$book_name::" >> book.db;

	echo -n "Book ISBN: ";
	read book_isbn;
	echo -n "$book_isbn::" >> book.db;
	
	echo -n "Book Price: ";
	read book_price;
	echo -n "$book_price::" >> book.db;
	
	echo -n "Book Numbers: ";
	read book_numbers;
	echo -e "$book_numbers" >> book.db;

	echo -e "Adding books sucessful!";
}
find_books()
{
	istrue=0;
	while [ $istrue == 0 ]
	do
		echo -e "Which book do you want to find?";
		echo -n "You want to find book by [Name|ISBN]: ";
		read find_type;
		if [ $find_type == "Name" ]
		then
			find_by_name;
		
		elif [ $find_type == "ISBN" ]
		then
			find_by_isbn;
		else 
			echo_choice_error;
		fi
	done 

}
find_by_name()
{
	echo -n "Book Name: ";
	read book_name;
	find=$(echo $(grep -w "$book_name" book.db ));
	name=$(echo $(grep -w "$book_name" book.db | awk -F '::' '{print $1}'));
	isbn=$(echo $(grep -w "$book_name" book.db | awk -F '::' '{print $2}'));
	price=$(echo $(grep -w "$book_name" book.db | awk -F '::' '{print $3}'));
	number=$(echo $(grep -w "$book_name" book.db | awk -F '::' '{print $4}'));

	if [ -z "$find" ]
	then
		echo "Sorry, can't found this book name!";
		echo_choice_error;
	else 
		echo -e "\n\nFound book $book_name!\n";
		echo -e -n "Book Name: ";
		echo -e "<<$name>>";
		echo -e -n "Book ISBN: ";
		echo -e "$isbn";
		echo -e -n "Book Price: ";
		echo -e "$price";
		echo -e -n "Book Number: ";
		echo -e "$number\n";
	fi
}

find_by_isbn()
{
	echo -n "Book ISBN: ";
	read book_isbn;
}

delete_books()
{
	echo -e;
}
update_books()
{
	echo -e;
}
echo_choice_error()
{
	echo -e "Sorry, your choice error, Please choice correct item!"
	echo -n "Try again?[y/n]: "
	read try;
	if [ $try == "n" ]
	then 
		istrue=1;
	fi
}
echo_error()
{
	echo -n "Username or password failed!(Try again?): ";
	read try;
	if [ $try == "n" ]
	then
		exit -1;
	fi
}
usr_login;
