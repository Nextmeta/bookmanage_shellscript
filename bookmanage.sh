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

	if [ "$user_name" == "hanwnz" ] && [ "$user_passwd" == "znwnahli1314" ]
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
		echo -e "5. List books";
		echo -e "6. Exit system";
		echo -n "Which item do you want to choice(1-6): ";
		read choice;
		case "$choice" in
			1) add_books;;
			2) find_books;;
			3) delete_books;;
			4) update_books;;
			5) list_books;;
			6) istrue=1;;
			*) echo_choice_error;;
		esac
	done 
}

add_books()
{
	echo -e "Which book do you want to adding?";
	echo -n "Book Name: ";
	read book_name;
	echo -n "$book_name::" >> .book.db;

	echo -n "Book ISBN: ";
	read book_isbn;
	echo -n "$book_isbn::" >> .book.db;
	
	echo -n "Book Price: ";
	read book_price;
	echo -n "$book_price::" >> .book.db;
	
	echo -n "Book Numbers: ";
	read book_numbers;
	echo -e "$book_numbers" >> .book.db;

	echo -e "Adding books sucessful!";
}
find_books()
{
	istrue=0;
	db_is_exist;
	isexist=$?;
	if [ $isexist == "0" ]
	then
		echo "No database!";
	else 
		while [ $istrue == 0 ]
		do
			echo -e "Which book do you want to find?";
			echo -n "You want to find book by [Name|ISBN]: ";
			read find_type;
			if [ "$find_type" == "Name" ]
			then
				find_by_name;	
			elif [ "$find_type" == "ISBN" ]
			then
				find_by_isbn;
			else 
				echo_choice_error;
			fi
			echo -e -n "Do you want to continue this operate?[y/n]:"
			read iscontinue;
		
			if [ "$iscontinue" == "y" ]
			then 
				continue;
			else
				break;
			fi 
		done 
	fi
}

db_is_exist()
{
	dbis_exist=$(find -name ".book.db");
	if [ -z $dbis_exist ]
	then 
		return 0;
	else
		return 1;
	fi 
}


find_by_name()
{
	echo -n "Book Name: ";
	read book_name;
	echo $book_name;
	name=$(echo $(awk -F '::' '{print $1}' ".book.db" | grep -w "$book_name"));
	if [ -z "$name" ]
	then
		echo "Sorry, can't found this book name!";
	else 
		isbn=$(echo $(grep -w "$book_name" .book.db | awk -F '::' '{print $2}'));
		price=$(echo $(grep -w "$book_name" .book.db | awk -F '::' '{print $3}'));
		number=$(echo $(grep -w "$book_name" .book.db | awk -F '::' '{print $4}'));
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
	echo $book_isbn >> tmpfile;
	linenum=$(grep -o "-" tmpfile| wc -l);
	if [ "$linenum" != 2 ]
	then 
		echo "Sorry, your isbn is error";
		rm -rf tmpfile;
		return;
	fi 
	deal_book_isbn=$(echo $(awk -F "-" '{print $1$2$3}' "tmpfile"));
	isbn=$(echo $(awk -F '::' '{print $2}' ".book.db" |
		awk -F "-" '{print $1$2$3}' | grep -w $deal_book_isbn))
	
	if [ "$isbn" != "$deal_book_isbn" ]
	then 
		echo "Sorry, can't found this book isbn!";
	else 
		name=$(echo $(grep -w "$book_isbn" .book.db | awk -F '::' '{print $1}'));
		price=$(echo $(grep -w "$book_isbn" .book.db | awk -F '::' '{print $3}'));
		number=$(echo $(grep -w "$book_isbn" .book.db | awk -F '::' '{print $4}'));
		echo -e "\n\nFound book $book_isbn!\n";
		echo -e -n "Book Name: ";
		echo -e "<<$name>>";
		echo -e -n "Book ISBN: ";
		echo -e "$book_isbn";
		echo -e -n "Book Price: ";
		echo -e "$price";
		echo -e -n "Book Number: ";
		echo -e "$number\n";
	fi
	rm -rf tmpfile;
}

get_booknum()
{
	local n=`wc -l ".book.db" | awk '{print $1}'`;
	echo $n;
}
print_list_book()
{
	printf "\n%-20s %-16s %-16s %-16s\n" "Book Name" "Book ISBN" "Book Price" "Book Number";
	line=`get_booknum`;
	i=0;

	while [ "$i" -lt "$line" ];
	do 
		i=$(($i+1));
		name=`cat ".book.db" | sed -n "$i"p"" ".book.db" | awk -F "::" '{print $1}'`;
		isbn=`cat ".book.db" | sed -n "$i"p"" ".book.db" | awk -F "::" '{print $2}'`;
		price=`cat ".book.db" | sed -n "$i"p"" ".book.db" | awk -F "::" '{print $3}'`;
		number=`cat ".book.db" | sed -n "$i"p"" ".book.db" | awk -F "::" '{print $4}'`;
		printf "%-20s %-16s %-16.2f %-16d\n" $name $isbn $price $number;

	done 
	
}
delete_books()
{
	db_is_exist;
	isexist=$?;
	if [ $isexist == "0" ]
	then
		echo "No database!"
	else 
		booknum=`get_booknum`;	
		echo $booknum;
		echo -n "Do you want to listing book information?[y/n]:";
		read islist;
		if [ "$islist" == "y" ]
		then
			echo -e "List of books:"
			print_list_book;
		fi 

		echo -e -n "\n\nWhich book do you want to delete?(1-$booknum)";
		read whichbook;
		if [ -z "$whichbook" ] || [ "$whichbook" -gt $booknum ] || [ "$whichbook" -lt 1 ]
		then 
			echo_choice_error;
		else 
			sed "$whichbook"d"" .book.db >> newfile
			cp newfile .book.db
			rm -rf newfile
			isempty=$(wc -l .book.db | awk -F ' ' '{print $1}')
			if [ "$isempty" == "0" ] 
			then
				rm -rf .book.db
			fi 
		fi 
	fi 
}
list_books()
{
	istrue=0;
	db_is_exist;
	isexist=$?;
	if [ $isexist == "0" ]
	then
		echo "No database!";
	else 
		print_list_book;
	fi
}
update_books()
{
	db_is_exist;
	isexist=$?;
	if [ $isexist == "0" ]
	then
		echo "No database!"
	else
		booknum=`get_booknum`;	
		echo $booknum;
		echo -n "Do you want to listing book information?[y/n]:";
		read islist;
		if [ "$islist" == "y" ]
		then
			echo -e "List of books:"
			print_list_book;
		fi 
		echo -e -n "\n\nWhich book do you want to update?(1-$booknum)";
		read whichbook;
		if [ -z "$whichbook" ] || [ "$whichbook" -gt $booknum ] || [ "$whichbook" -lt 1 ]
		then 
			echo_choice_error;
		else
			# not complete
			isempty=$(wc -l .book.db | awk -F ' ' '{print $1}');
			echo -e -n "Book Name: ";
			read book_name;
			echo -e -n "Book ISBN: ";
			read book_isbn;
			echo -e -n "Book Price: ";
			read book_price;
			echo -e -n "Book Number: ";
			read book_number;
			
			insert=$(echo -e "$book_name::$book_isbn::$book_price::$book_number");
			if [ "$isempty" == "0" ]
			then 
				sed -i "$whichbook"d"" .book.db;
				echo -e "$insert" > .book.db;
				return;
			fi
			echo $whichbook and $booknum;	
			if [ "$whichbook" == "1" ] 
			then 
				# first line 
				sed -i "$whichbook"d"" .book.db;
				sed -i "1s/^/$insert\n/" .book.db; 
			elif [ "$whichbook" == "$booknum" ]
			then    
				# last line 
				sed -i "$whichbook"d"" .book.db;
				echo -e "$insert" >> .book.db;
			else
				sed -i "N;$whichbook"a"$insert" .book.db;
				sed -i "$whichbook"d"" .book.db;
			fi 
		fi 
	fi 
}
echo_choice_error()
{
	echo -e "Sorry, your choice error, Please choice correct item!"
	echo -n "Try again?[y/n]: "
	read try;
	if [ "$try" == "n" ]
	then 
		istrue=1;
	fi
}
echo_error()
{
	echo -n "Username or password failed!(Try again?): ";
	read try;
	if [ "$try" == "n" ]
	then
		exit -1;
	fi
}
usr_login;
