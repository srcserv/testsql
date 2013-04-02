grammar psqlgrammar;

options {
  language = Java;
  backtrack=true;
  memoize=true;
}

tokens {
  IS =  'IS';
	POLYMORPHIC = 'POLYMORPHIC';
	BETWEEN = 'BETWEEN';
	NOT ='NOT';
	
	
	
}

@header {
import java.util.HashMap;

}

@members {

HashMap memory = new HashMap();
HashMap memory2 = new HashMap();
HashMap memory3 = new HashMap();


class Mark {
	int begin;
	int end;
}


}





start_select    :   direct_select_statement_multiple_rows	{System.out.println(); System.out.println("direct_select_statement_multiple_rows ==> " + $direct_select_statement_multiple_rows.text);};


/*
		 5.4 Names and identifiers (p151)
*/
fully_qualified_identifier       
	options{k=1;}  				 
	:  identifier  ( Period  identifier (  Period  identifier )? )?;
	
column_reference
	options{k=1;}  				 
	: 	identifier_chain | 'MODULE' Period identifier  Period identifier;

/*
		 5.3 <literal> (p143)
*/
general_literal
	options{k=1;}
	:	Character_String_Literal
	//|	National_Character_String_Literal
	//|	Bit_String_Literal
	//|	Hex_String_Literal
	|	boolean_literal
	//|	day_time_literal
	//|	interval_literal
	;

boolean_literal             :  'TRUE' | 'FALSE' | 'UNKNOWN';
/*
signed_numeric_literal   :  Signed_Integer | Signed_Large_Integer | Signed_Float;

unsigned_numeric_literal  :  Unsigned_Integer | Unsigned_Large_Integer | Unsigned_Float ;

literal
	options{k=1;}
	:	Signed_Integer
	|	Signed_Float
	|	general_literal ;
	
*/

sign   :  Plus_Sign | Minus_Sign;

	
//datetime_literal            :     | time_literal  | timestamp_literal ;

//                :   'DATE' Quote years_value  Minus_Sign months_value Minus_Sign days_value  Quote  ;
//2              :   days_value Minus_Sign  months_value2 Minus_Sign  years_value  ;
//                :   years_value  Minus_Sign months_value Minus_Sign days_value ;
//date_literal                :   years_value Minus_Sign months_value Minus_Sign days_value ;
/*
date_literal                :    days_value {System.out.print($days_value.text);} oneminus=Minus_Sign {System.out.print($oneminus.text);}
                                         months_value {System.out.print($months_value.text);} twominus=Minus_Sign {System.out.print($twominus.text);} 
                                         years_value {System.out.print($years_value.text);};
*/
date_literal                :    days_value  oneminus=Minus_Sign {System.out.print($oneminus.text);}
                                         months_value  twominus=Minus_Sign {System.out.print($twominus.text);} 
                                         years_value ;
                                         

/*
interval_literal            :   'INTERVAL'
                                Quote ( Plus_Sign | Minus_Sign )? ( year_month_literal | day_time_literal ) Quote;
*/
year_month_literal          :  years_value  | years_value  Minus_Sign months_value ;



days_value                  :  Unsigned_Integer {System.out.print($Unsigned_Integer.text);};
//days_value                  :  unsigned_numeric_literal;

//months_value                :  Unsigned_Integer ;
//months_value2                :  Regular_Identifier ;
//months_value                :  unsigned_numeric_literal;
months_value                :  Regular_Identifier {System.out.print( $Regular_Identifier.text);};

years_value                 :  Unsigned_Integer {System.out.print($Unsigned_Integer.text);};
//years_value		: unsigned_numeric_literal;

col_literal		: col_value Minus_Sign {System.out.print($Minus_Sign.text);} col_number;

col_value		:  Regular_Identifier {System.out.print( $Regular_Identifier.text);};

col_number		:  Unsigned_Integer2 {System.out.print($Unsigned_Integer2.text);};
//col_nunber		:  Digit;

/*
	6 Scalar expressions

		 6.1 <data type> (p161)
*/

char_length_units
	: 	'CHARACTERS' | 'CODE_UNITS' | 'OCTETS';



direct_select_statement_multiple_rows
	:	cursor_specification ;
/*
cursor_specification
	:	query_expression ; //(order_by_clause)? (updatability_clause)?
*/
	
cursor_specification
	:	query_expression (order_by_clause)?;  //(order_by_clause)? (updatability_clause)?

order_by_clause   :  'ORDER' 'BY' sort_specification_list ;

query_expression
	:	query_expression_body;

/*
query_expression_body
	:	query_term; //| 
		//( query_expression_body 'UNION' ('ALL' | 'DISTINCT')? corresponding_spec? query_term ) | 
		//( query_expression_body 'EXCEPT' ('ALL' | 'DISTINCT')? corresponding_spec? query_term);
*/

query_expression_body
	options {k=1;}
	:	non_join_query_expression  | joined_table ;

//  query_expression_body   :  non_join_query_expression  | joined_table ;

non_join_query_expression
	options {k=1;}
	:	(	non_join_query_term
		|	joined_table  ( 'UNION' {System.out.print(" UNION ");} | 'EXCEPT' {System.out.print(" EXCEPT ");}) 
				( 'ALL' {System.out.print(" ALL ");} | 'DISTINCT' {System.out.print(" DISTINCT ");})?  query_term
		)
		( ( 'UNION' {System.out.print(" UNION ");} | 'EXCEPT' {System.out.print(" EXCEPT ");}) ( 'ALL' {System.out.print(" ALL ");}
		   | 'DISTINCT' {System.out.print(" DISTINCT ");} )?  query_term )*
	;
/*
query_term
	:	query_primary; //| (query_term 'INTERSECT' ('ALL' | 'DISTINCT')? corresponding_spec? query_primary;
*/

query_term
	options {k=1;}
	:  non_join_query_term  | joined_table ;

//query_term   :  non_join_query_term  | joined_table ;

non_join_query_term
	options {k=1;}
	:	(	non_join_query_primary
		|	joined_table  'INTERSECT' {System.out.print(" INTERSECT ");} ( 'ALL' {System.out.print(" ALL ");} | 'DISTINCT' {System.out.print(" DISTINCT ");} )?  query_primary
		)
		(	'INTERSECT' {System.out.print(" INTERSECT ");} ( 'ALL' {System.out.print(" ALL ");}| 'DISTINCT' {System.out.print(" DISTINCT ");})?  query_primary )*
	;

query_primary
	options {k=1;}
	:	non_join_query_primary
	|	joined_table ;

non_join_query_primary
	options {k=1;}
	:	simple_table
	;			//|	Left_Paren non_join_query_expression  Right_Paren
simple_table	:	query_specification ;

//query_specification :  'SELECT' ( set_quantifier  )? select_list  table_expression ;
query_specification :  'SELECT' {System.out.print("SELECT ");} ( set_quantifier  )? select_list table_expression ;
set_quantifier   :  'DISTINCT' {System.out.print("DISTINCT ");} | 'ALL' {System.out.print("ALL ");};
select_list :	Asterisk {System.out.print($Asterisk.text);} |	select_sublist  ( Comma {System.out.print($Comma.text + " ");} select_sublist  )*;
select_sublist : 	derived_column |	qualified_asterisk ;

derived_column:	value_expression ( as_clause  )?;
value_expression
	options {k=1;}
	:	common_value_expression
	|	boolean_value_expression
	//|	row_value_expression
	;

	
common_value_expression
	:	numeric_value_expression
		| string_value_expression
	;
/*
		 6.26 numeric_value_expression  (p240)

Specify a numeric value.
*/

numeric_value_expression
	options{k=1;}
	:	term ( ( Plus_Sign | Minus_Sign ) term )*
	;

term
	options{k=1;}
	:	factor ( ( Asterisk | Slash ) factor )*
	;

factor
	options{k=1;}
	:  ( sign  )? numeric_primary ;

numeric_primary
	options{k=1;}
	:	value_expression_primary
	|	numeric_value_function
	;

/*
		 6.27 numeric_value_function  (p242)


Specify a function yielding a value of type numeric.
*/

numeric_value_function
	options{k=1;}
	: absolute_value_expression;
	
absolute_value_expression   :  'ABS' Left_Paren numeric_value_expression  Right_Paren;	


/*
		 6.28 string_value_expression  (p251)


Specify a character string value or a binary string value.
*/

string_value_expression
	
	:	character_value_expression; //  | blob_value_expression ;

character_value_expression
	
	:	character_factor ( Concatenation_Operator  character_factor )*;
// character_value_expression   :  concatenation  | character_factor ;

// concatenation   :  character_value_expression  Concatenation_Operator  character_factor ;

character_factor
	
	:	character_primary
		;
/*
character_primary
	
	:	value_expression_primary ;
*/	
character_primary
	options{k=1;}
	:	value_expression_primary
	|	string_value_function ;
	
/*
		 6.29 string_value_function  (p255)


Specify a function yielding a value of type character string or binary string.
*/
/*
string_value_function
	options{k=1;}
	:	character_value_function
	|	blob_value_function ;
*/
string_value_function
	options{k=1;}
	:	character_value_function
	;
/*
character_value_function
	options{k=1;}
	:	character_substring_function
	|	regular_expression_substring_function
	|	fold
	|	transcoding
	|	character_transliteration
	|	trim_function
	|	character_overlay_function
	|	normalize_function
	|	specific_type_method
	;
*/
/*
character_value_function
	options{k=1;}
	:	character_substring_function
	|	regular_expression_substring_function
	|	fold
	|	transcoding
	|	character_transliteration
	|	trim_function
	|	character_overlay_function
	|	normalize_function
	|	specific_type_method
	;
*/
character_value_function
	options{k=1;}
	:		character_substring_function
			| regular_expression_substring_function
			| fold	
			| trim_function;
	
fold
	options{k=1;}
	:	( 'UPPER' | 'LOWER' )
		Left_Paren
			character_value_expression
		Right_Paren;
		
character_substring_function
	options{k=1;}
	:	'SUBSTRING'
		Left_Paren
			character_value_expression
			'FROM' start_position
			( 'FOR' string_length  )?
			( 'USING' char_length_units  )?
		Right_Paren;
		
regular_expression_substring_function
	options{k=1;}
	:	'SUBSTRING'
		Left_Paren
			character_value_expression
			'SIMILAR' character_value_expression
			'ESCAPE' Character_String_Literal
		Right_Paren;

trim_function
	options{k=1;}
	:	'TRIM'
		Left_Paren
			trim_operands
		Right_Paren;

trim_operands
	options{k=1;}
	:	trim_source
	|	trim_specification	// ( trim_specification )?
		( trim_character  )?
		'FROM'
		trim_source ;

trim_source   :  character_value_expression ;

trim_specification   :  'LEADING' | 'TRAILING' | 'BOTH';

trim_character   :  character_value_expression ;
		
start_position   :  numeric_value_expression ;

string_length   :  numeric_value_expression ;
/*
value_expression_primary
	options{k=1;}
	:	(	parenthesized_value_expression
		|	
		|	column_reference
		|	set_function_specification
		|	window_function
		|	scalar_subquery
		|	case_expression
		|	cast_specification
		|	subtype_treatment
		|	static_method_invocation
		|	new_specification
		|	reference_resolution
		|	collection_value_constructor
		|	multiset_element_reference
		|	routine_invocation
		|	next_value_expression
		|	generalized_invocation
		)
		(	 Period identifier  ( sql_argument_list )?
		|	 Right_Arrow  identifier ( sql_argument_list )?
		|	( Concatenation_Operator  value_expression_primary )*  left_bracket_or_trigraph numeric_value_expression  right_bracket_or_trigraph
		)*
	;
*/	
//value_expression_primary 
// : (  )	(	 Period identifier  | 	Right_Arrow  identifier )* ;
//value_expression_primary 
//  : (  )	(	 Period ('a'..'z'|'A'..'Z')+  | 	Right_Arrow  identifier )* ; 


 value_expression_primary 
  : ( unsigned_value_specification )	(	 Period identifier  | 	Right_Arrow  identifier )* ; 

/*
		 7.4 <table expression> (p300)


Specify a table or a grouped table.
*/

table_expression
	options {k=1;}
	:	from_clause
		( where_clause  )?
		( group_by_clause  )?
		( having_clause  )?
		//( window_clause  )?
		;

/*
		 7.5 from_clause  (p301)


Specify a table derived from one or more tables.
*/
/*
from_clause
	:	'FROM'
		table_reference_list ;		
*/
from_clause
	:  {System.out.print(" ");}	'FROM'  {System.out.print("FROM ");}
		table_reference_list ;
// $<Group1

table_reference_list
	options {k=1;}
	:	table_reference
		( Comma {System.out.print($Comma.text);} table_reference  )*;	
/*
boolean_predicand
	:
                       	
	;
	
	
  :
		unsigned_value_specification;
		
unsigned_value_specification
	:	Unsigned_Integer
	|	ecification ;
	
ecification
	:
	identifier_chain;
	
identifier_chain   				 
                     :  identifier  ( Period identifier  )*;

identifier   	   :  
	Regular_Identifier ; 
	
	
*/

// $>
	
as_clause :	( 'AS' )? identifier ;

qualified_asterisk :	schema_name  Period Asterisk  ;
//qualified_asterisk :	identifier_chain  Period Asterisk  ;	
//|	all_fields_reference

//
schema_name                      
	options{k=1;}  				 
	:  identifier  ( Period  identifier )? ;
//schema_name                      options{k=1;}  				 
//	:  ('a'..'z'|'A'..'Z')+  ( Period  ('a'..'z'|'A'..'Z')+ )? ;

//schema_name                      
//	options{k=1;}  				 
//	:  identifier_chain ;
	
	 //                    	:('a'..'z'|'A'..'Z')+	ic;
 //ic 	:  (  ('a'..'z'|'A'..'Z')+  )*;
/*
		 7.6 table_reference  (p303)

Reference a table.
*/

table_reference
	options {k=1;}
	:	(	table_primary 
		|	 joined_table
		)
		( sample_clause )?;

//table_reference   :  _or_joined_table  ( sample_clause  )?;

// _or_joined_table   :    | joined_table ;

sample_clause
	:	'TABLESAMPLE' sample_method
		Left_Paren {System.out.print($Left_Paren.text);} numeric_value_expression  Right_Paren {System.out.print($Right_Paren.text);}
		( repeatable_clause  )?;

sample_method
	:	'BERNOULLI'
	|	'SYSTEM';

repeatable_clause
	:	'REPEATABLE' Left_Paren numeric_value_expression  Right_Paren;

//sample_percentage   :	numeric_value_expression ;

//repeat_argument   :  numeric_value_expression ;

table_primary  :
		table_or_query_name  ( ( 'AS' )? {System.out.print(" ");} identifier   ( Left_Paren derived_column_list  Right_Paren )? )?
		|	derived_table  ( 'AS' )? (identifier)?  ( Left_Paren derived_column_list  Right_Paren )?
		|	Left_Paren joined_table  Right_Paren
	
	;
/* The followings are for table_primary. 10/4/11

|	derived_table  ( AS )? identifier  ( Left_Paren derived_column_list  Right_Paren )?
	|	lateral_derived_table  ( AS )? identifier  ( Left_Paren derived_column_list  Right_Paren )?
	|	collection_derived_table  ( AS )? identifier  ( Left_Paren derived_column_list  Right_Paren )?
	|	table_function_derived_table  ( AS )? identifier  ( Left_Paren derived_column_list  Right_Paren )?
	|	only_spec  ( ( AS )? identifier  ( Left_Paren derived_column_list  Right_Paren )? )?
	|	Left_Paren joined_table  Right_Paren

*/

//only_spec   :  'ONLY' Left_Paren table_or_query_name  Right_Paren;

//lateral_derived_table   :  'LATERAL' table_subquery ;

//collection_derived_table   :  UNNEST Left_Paren collection_value_expression  Right_Paren ( WITH ORDINALITY )?;

//table_function_derived_table   :  TABLE Left_Paren collection_value_expression  Right_Paren;

//derived_table   :  table_subquery ;
/*
table_or_query_name   :  table_name  ;  // | identifier
*/
table_or_query_name   :  table_name  | identifier ;

derived_table   :  table_subquery ;

derived_column_list   :  column_name_list ;

//column_name_list   
//	options {k=1;}
//	:  identifier  ( Comma identifier  )*;


/*
		 7.7 joined_table  (p312)


Specify a table derived from a Cartesian product, inner or outer join, or union join.
*/



joined_table  :
	table_primary
	(
		//( 	sample_clause  )?
		(	'CROSS' {System.out.print(" CROSS");} 'JOIN' {System.out.print(" JOIN ");} table_primary
		|	( join_type  )? 'JOIN' {System.out.print(" JOIN ");} table_reference  join_specification
		|	'NATURAL' {System.out.print(" NATURAL");} ( join_type  )? 'JOIN' {System.out.print(" JOIN");} table_primary
		|	 'UNION' {System.out.print(" UNION");} 'JOIN' {System.out.print(" JOIN ");} table_primary
		)
	)+
	;
/*
table_primary  :
		table_or_query_name  ( ( 'AS' )? identifier  ( Left_Paren derived_column_list  Right_Paren )? )?
		;
*/
		
//table_or_query_name   :  table_name   ;  //| identifier
/*
table_name                       
	 				 
	:  	
		identifier
	;
*/
//options{k=1;} 		
 //( 'MODULE' Period identifier
//| identifier  ( Period  identifier (  Period  identifier )? )?

table_name                       
	options{k=1;}  				 
	:  	( 'MODULE' Period identifier
		| identifier  ( Period  identifier (  Period  identifier )? )?
		);

//joined_table  :
//); 		cross_join
//	|	qualified_join
//	|	natural_join
//	|	union_join
//	;

//cross_join   		:  table_reference  CROSS JOIN table_primary ;

//qualified_join   	:  table_reference  ( join_type  )? JOIN table_reference  join_specification ;

//natural_join   		:  table_reference  NATURAL ( join_type  )? JOIN table_primary ;

//union_join   		:  table_reference  UNION JOIN table_primary ;

join_specification  :  join_condition  | named_columns_join ;

join_condition   	:  'ON' {System.out.print(" ON ");} search_condition ;

named_columns_join  :  'USING' {System.out.print(" USING ");} Left_Paren {System.out.print($Left_Paren.text);} join_column_list  Right_Paren {System.out.print($Right_Paren.text);};

join_type   		:  'INNER' {System.out.print(" INNER ");} | outer_join_type  ( 'OUTER' {System.out.print("OUTER ");})? ;

outer_join_type   	:  'LEFT' {System.out.print(" LEFT ");} | 'RIGHT' {System.out.print(" RIGHT ");} | 'FULL' {System.out.print(" FULL ");};

join_column_list   	:  column_name_list ;

//derived_column_list   :  column_name_list ;

column_name_list   
	options {k=1;}
	:  identifier  ( Comma identifier  )*;


unsigned_value_specification
 options {k=1;}
	:	date_literal
	|	col_literal
	|	Unsigned_Integer	{System.out.print($Unsigned_Integer.text);}
	|	general_value_specification ;
	
general_value_specification
 options {k=1;}
	
	:identifier_chain;


	
identifier_chain   				 
                     :  identifier  ( Period {System.out.print($Period.text);}  identifier  )*;

//identifier_chain   				 
                     //:  identifier  ( Period identifier  )*;
                     
                     
 //                    	:('a'..'z'|'A'..'Z')+	ic;
 //ic 	:  (  ('a'..'z'|'A'..'Z')+  )*;

identifier   	   
options{k=1;}   
	                  :      Regular_Identifier {System.out.print( $Regular_Identifier.text);};

/*
		 6.26 numeric_value_expression  (p240)

Specify a numeric value.
*/
/*
numeric_value_expression
	options{k=1;}
	:	term ( ( Plus_Sign | Minus_Sign ) term )*
	;

term
	options{k=1;}
	:	factor ( ( Asterisk | Slash ) factor )*
	;

factor
	options{k=1;}
	:  ( sign  )? numeric_primary ;

numeric_primary
	options{k=1;}
	:	value_expression_primary
	
	;  //|	numeric_value_function
*/
//sign   :  Plus_Sign | Minus_Sign;



/*
		 7.8 where_clause  (p319)

*/

where_clause   :  {System.out.print(" ");} 'WHERE' {System.out.print("WHERE ");} search_condition ;

/*
		 7.9 group_by_clause  (p320)


Specify a grouped table derived by the application of the group_by_clause  to the result of the
previously specified clause.
*/

group_by_clause   :  'GROUP' 'BY' ( set_quantifier  )? grouping_element_list ;

grouping_element_list   :  grouping_element  ( Comma grouping_element  )*;

grouping_element  :
		ordinary_grouping_set
	|	rollup_list
	|	cube_list
	|	grouping_sets_specification
	|	empty_grouping_set
	;

ordinary_grouping_set  :
		grouping_column_reference
	|	Left_Paren grouping_column_reference_list  Right_Paren
	;

grouping_column_reference   :  column_reference  ( collate_clause  )?;

grouping_column_reference_list   :  grouping_column_reference  ( Comma grouping_column_reference  )*;

rollup_list   :  'ROLLUP' Left_Paren ordinary_grouping_set_list  Right_Paren;

ordinary_grouping_set_list   :  ordinary_grouping_set  ( Comma ordinary_grouping_set  )*;

cube_list   :  'CUBE' Left_Paren ordinary_grouping_set_list  Right_Paren;

grouping_sets_specification   :  'GROUPING' 'SETS' Left_Paren grouping_set_list  Right_Paren;

grouping_set_list   :  grouping_set  ( Comma grouping_set  )*;

grouping_set  :
		ordinary_grouping_set
	|	rollup_list
	|	cube_list
	|	grouping_sets_specification
	|	empty_grouping_set
	;

empty_grouping_set   :  Left_Paren Right_Paren;

/*
		 7.10 having_clause  (p329)


Specify a grouped table derived by the elimination of groups that do not satisfy a search_condition .
*/

having_clause   :  'HAVING' search_condition ;




search_condition   :  boolean_value_expression ;

/*
		 6.34 boolean_value_expression  (p277)*/

boolean_value_expression
	options{k=1;}
	:	boolean_term ( 'OR' {System.out.print(" " + "OR" + " ");} boolean_term )* 
	;

boolean_term
	options {k=1;}
	:	boolean_factor ( 'AND' {System.out.print(" " + "AND" + " ");} boolean_factor )*
	;

boolean_factor
	options {k=1;}
	:  ( 'NOT' )? boolean_test ;

boolean_test
	options {k=1;}
	:  boolean_primary  ( 'IS' ( 'NOT' )? truth_value  )?;

truth_value   :  'TRUE' | 'FALSE' | 'UNKNOWN';

/*
boolean_primary
	options {k=1;}
	:	predicate
	|	boolean_predicand;
*/

boolean_primary
	options {k=1;}
	:predicate
	| boolean_predicand;

boolean_predicand
	options {k=1;}
	:	parenthesized_boolean_value_expression
	|	nonparenthesized_value_expression_primary
	;


parenthesized_boolean_value_expression
	options {k=1;}
	:  Left_Paren {System.out.print($Left_Paren.text);} boolean_value_expression  Right_Paren {System.out.print($Right_Paren.text);};

/*

	options {k=1;}
	:	unsigned_value_specification
	|	column_reference
	|	set_function_specification
	|	window_function
	|	scalar_subquery
	|	case_expression
	|	cast_specification
	|	subtype_treatment
	|	static_method_invocation
	|	new_specification
	|	reference_resolution
	|	collection_value_constructor
	|	multiset_element_reference
	|	routine_invocation
	|	next_value_expression
	|	generalized_invocation

	|	value_expression_primary ( Concatenation_Operator  value_expression_primary )*  left_bracket_or_trigraph numeric_value_expression  right_bracket_or_trigraph
	|	value_expression_primary  Period identifier  ( sql_argument_list )?
	|	value_expression_primary  Right_Arrow  identifier ( sql_argument_list )?
	|	value_expression_primary  Period identifier
	;
*/

  nonparenthesized_value_expression_primary :
		unsigned_value_specification
		|	set_function_specification
		| scalar_subquery;
		
/*
		 6.9 set_function_specification  (p191)
*/

set_function_specification   
	options{k=1;}
	:  aggregate_function  | grouping_operation ;

grouping_operation   :  'GROUPING' Left_Paren column_reference  ( Comma column_reference  )* Right_Paren;


/*
		 7.15 <subquery> (p368)


Specify a scalar value, a row, or a table derived from a query_expression .
*/

scalar_subquery   
	options {k=1;}
	:  subquery ;

row_subquery
	options {k=1;}
	:  subquery ;

table_subquery   :  subquery ;


subquery
	options {k=1;}
	:  Left_Paren {System.out.print($Left_Paren.text);} query_expression  Right_Paren {System.out.print($Right_Paren.text);};

/*
subquery
	options {k=1;}
	:  query_expression;
*/		
/*
	8 Predicates

		 8.1 predicate  (p371)

Specify a condition that can be evaluated to give a boolean value.
*/

/*
predicate
	options {k=1;}
	:	comparison_predicate
	|	between_predicate
	|	in_predicate
	|	
	|	similar_predicate
	|	null_predicate
	|	quantified_comparison_predicate
	|	exists_predicate
	|	unique_predicate
	|	normalized_predicate
	|	match_predicate
	|	overlaps_predicate
	|	distinct_predicate
	|	member_predicate
	|	submultiset_predicate
	|	set_predicate
	|	type_predicate
	;
*/
/*
predicate
	options {k=1;}
	:	comparison_predicate
	|	between_predicate
	|	in_predicate
	|	like_predicate
	;
*/

predicate
	options {k=1;}
	: comparison_predicate
	| like_predicate
	| between_predicate
	| in_predicate
	| quantified_comparison_predicate
	| polymorphic_between_predicate
	| polymorphic_range_predicate
	| ontology_child_predicate
	
	;
/*
		 8.2 comparison_predicate  (p373)

Specify a comparison of two row values.
*/

comparison_predicate
	options {k=1;}
	:  row_value_predicand  comparison_predicate_part_2 ;

comparison_predicate_part_2
	options {k=1;}
	:  comp_op  row_value_predicand ;

comp_op  :
		Equals_Operator	{System.out.print(" " + $Equals_Operator.text + " ");}
	|	Not_Equals_Operator	{System.out.print(" " + $Not_Equals_Operator.text + " ");}
	|	Less_Than_Operator	{System.out.print(" " + $Less_Than_Operator.text + " ");}
	|	Greater_Than_Operator	{System.out.print(" " + $Greater_Than_Operator.text + " ");}
	|	Less_Or_Equals_Operator	{System.out.print(" " + $Less_Or_Equals_Operator.text + " ");}
	|	Greater_Or_Equals_Operator {System.out.print(" " + $Greater_Or_Equals_Operator.text + " ");}
	;
	
/*
		 8.5 like_predicate  (p383)


Specify a pattern-match comparison.
*/

like_predicate 
	:	character_like_predicate;

character_like_predicate   :  row_value_predicand  character_like_predicate_part_2 ;
//character_like_predicate   :  row_value_predicand  ;

/*
row_value_predicand
	
	:	
	row_value_special_case |   
	row_value_constructor_predicand
	;
	
*/
/*
row_value_predicand
	
	:	
	row_value_special_case 
	;
*/
//	
row_value_special_case
	
	:  nonparenthesized_value_expression_primary ;
	
row_value_constructor_predicand

	:	
	boolean_predicand
	//|	 common_value_expression
	| common_value_expression
	;
/*
common_value_expression
	options {k=1;}
	:	numeric_value_expression
	|	string_value_expression
	|	datetime_value_expression
	|	interval_value_expression
	|	collection_value_expression
	|	reference_value_expression
*/	

/*
character_like_predicate_part_2
	
	:  ( 'NOT' )? 'LIKE'  Single_Quote character_pattern Single_Quote  ( 'ESCAPE'  Character_String_Literal )?  {System.out.println("LIKE" + " character_pattern ==> "
	    + $character_pattern.text+ " ESCAPE " + "Character_String_Literal ==> " + $Character_String_Literal.text);};
*/	    
character_like_predicate_part_2
	
	:  ( 'NOT' )? 'LIKE'  Single_Quote character_pattern Single_Quote  ( 'ESCAPE'  Character_String_Literal )?  ;	  

character_pattern   :  character_value_expression ;


/*
		 8.8 quantified_comparison_predicate  (p397)


Specify a quantified comparison.
*/

quantified_comparison_predicate   :  row_value_predicand  quantified_comparison_predicate_part_2 ;

quantified_comparison_predicate_part_2
	options {k=1;}
	:  comp_op  quantifier  table_subquery ;

quantifier   :  all  | some ;

all   :  'ALL';

some   :  'SOME' | 'ANY';


//Character_String_Literal :
//		  Quote ( Extended_Latin_Without_Quotes  )* Quote ( Quote ( Extended_Latin_Without_Quotes  )* Quote )*
/*
Character_String_Literal :
		  Quote ( ID2  )* Quote ( Quote ( ID2  )* Quote )*
		;
*/
/*
Character_String_Literal :
		 Quote Basic_Latin_Without_Quotes 	{System.out.println("Basic_Latin_Without_Quotes ==> " + $Basic_Latin_Without_Quotes.text);}
		;
*/		
Character_String_Literal :
		 Single_Quote Basic_Latin_Without_Quotes Single_Quote
		;
/*
		 8.3 between_predicate  (p380)


Specify a range comparison.
*/

between_predicate   :  row_value_predicand  between_predicate_part_2 ;

between_predicate_part_2
	:    ('NOT' {System.out.print("NOT ");} )? 'BETWEEN' {System.out.print(" BETWEEN ");} 
	     ( 'ASYMMETRIC' {System.out.print(" ASYMMETRIC ");} | 'SYMMETRIC' {System.out.print(" SYMMETRIC ");})? 
	     row_value_predicand  'AND' {System.out.print(" AND ");} row_value_predicand ;


in_predicate   :  row_value_predicand  in_predicate_part_2  ;

/*
row_value_predicand
	options {k=1;}
	:	row_value_special_case
	|	row_value_constructor_predicand
	;
*/

		
in_predicate_part_2
	options {k=1;}
	:  ( 'NOT' )? 'IN' in_predicate_value ;

in_predicate_value  :
		table_subquery
	//|	Left_Paren in_value_list  Right_Paren
	| Left_Paren {System.out.print($Left_Paren.text);} in_value_list  Right_Paren {System.out.print($Right_Paren.text);}
	;

in_value_list   :  row_value_expression  ( Comma row_value_expression  )*;
	
row_value_expression
	options {k=1;}
	:	row_value_special_case
	|	explicit_row_value_constructor;

explicit_row_value_constructor
	options {k=1;}
	:	Left_Paren {System.out.print($Left_Paren.text);} row_value_constructor_element  Comma {System.out.print($Comma.text);}row_value_constructor_element_list  Right_Paren {System.out.print($Right_Paren.text);}
	|	'ROW' Left_Paren {System.out.print($Left_Paren.text);} row_value_constructor_element_list  Right_Paren {System.out.print($Right_Paren.text);}
	|	row_subquery
	;
row_value_constructor_element_list  :
		row_value_constructor_element  ( Comma {System.out.print($Comma.text);} row_value_constructor_element  )*;

row_value_constructor_element   
	options {k=1;}
	:  value_expression ;
	

/*
	Polymorphic Between Predicate
*/
/*
polymorphic_between_predicate	: 	polymorphic_begin polymorphic_part_2;

polymorphic_begin		: 	Regular_Identifier;

//polymorphic_part_2		:	(NOT)? (Space)? IS Space POLYMORPHIC Space BETWEEN Space polymorphic_between_value;
polymorphic_part_2		:	(NOT)?  IS  POLYMORPHIC  BETWEEN  polymorphic_between_value;
polymorphic_between_value		:	Left_Paren stringLiteral Right_Paren;

//stringLiteral 			:(Single_Quote)?   (Regular_Identifier)* (Single_Quote)? (Comma  (Single_Quote)? (Regular_Identifier | Space )* ( Single_Quote)?)* ;
stringLiteral 			:(Single_Quote)?   (Regular_Identifier)* (Single_Quote)? (Comma  (Single_Quote)? (Regular_Identifier )* ( Single_Quote)?)* ;

*/

polymorphic_between_predicate   :  row_value_predicand  polymorphic_between_predicate_part_2  ;


row_value_predicand

	:	(onequote=Single_Quote {System.out.print($onequote.text);} )?  row_value_special_case (twoquote=Single_Quote {System.out.print($twoquote.text);})? 
	|	row_value_constructor_predicand
	;

/*
row_value_predicand

	:	(onequote=Single_Quote {System.out.print($onequote.text);} )?  row_value_special_case (twoquote=Single_Quote {System.out.print($twoquote.text);})? 
	| 	col_literal
	|	row_value_constructor_predicand
	;
*/
		
polymorphic_between_predicate_part_2
	options {k=1;}
	:  ('NOT' {System.out.print("NOT ");})? 'IS'  {System.out.print(" IS ");} 'POLYMORPHIC' {System.out.print("POLYMORPHIC ");}
	 'BETWEEN' {System.out.print("BETWEEN ");} polymorphic_between_value 
	;

polymorphic_between_value  :
		//table_subquery
	//|	Left_Paren in_value_list  Right_Paren
	(Left_Paren {System.out.print($Left_Paren.text);})? species_variant_list  (Right_Paren {System.out.print($Right_Paren.text);})?
	;

//species_variant_list   :  row_value_expression  ( Comma row_value_expression  )*;
//species_variant_list   :  (Single_Quote)? row_value_expression  (Single_Quote)? ( Comma (Single_Quote)? row_value_expression  (Single_Quote)?)*;
species_variant_list     
		@init   {

	int counter = 0;
	int counter2 = 0;
	int beginone = 0;
	int wcounter = 0;
	Mark marker = new Mark();	
	StringBuffer z = new StringBuffer();
	StringBuffer n = new StringBuffer();
	StringBuffer zz = new StringBuffer();
	
}


	:  (one=Single_Quote {System.out.print($one.text);})? ( e=non_terminal_identifier {
		
		counter2 = counter2 + 1; 
		Integer k = new Integer(counter2);
		memory2.put(k , $e.value);
	
	})* { for ( int j = 1; j <= counter2 ; j++) {
	      if ( j == 1) {
                             	String m = (String) memory2.get(j);
                           	n.insert(0, m);
                             }
                             else
                             	{ 
                             	 	String m = (String) memory2.get(j);
                        		n.append(" ");
                             		n.append(m);
                             }

	}   
	System.out.print(n.toString());}
                             (two=Single_Quote {System.out.print($two.text);})? ( Comma   (three=Single_Quote )? {beginone = counter + 1;  
				       marker.begin = beginone; 
	                                                                           }
	                                                                           
	                                                                           ( e=non_terminal_identifier {
		
		counter = counter + 1; 
		Integer w = new Integer(counter);
		memory.put(w , $e.value);
	
	})* (four=Single_Quote )? {marker.end = counter; 
		          Integer g = new Integer(wcounter);
		          Mark h = new Mark();
		          h.begin = marker.begin;
                                                       h.end = marker.end;
		          memory3.put(g, h);
		          wcounter = wcounter + 1;
		          } )*    {

for (int ee = 0; ee < memory3.size(); ee++) {

	System.out.print($Comma.text);
	System.out.print($three.text);
 	Mark  ff = (Mark) memory3.get(ee);	
             	int startword = ff.begin;
             	int endword = ff.end;
         
	for ( int ii = startword; ii <= endword ; ii++) {
	
	      if ( ii == startword) {
                             	String yy = (String) memory.get(ii);
                             	zz.insert(0, yy);
                             }
                             else
                             	{ 
                             	 	String yy = (String) memory.get(ii);
                        		zz.append(" ");
                             		zz.append(yy);
                             }
	       	       
	}	       	
        
        System.out.print(zz.toString());
        zz.delete(0,zz.length());
        System.out.print($four.text);	       
} //end of size loop
//System.out.println();
}
	| NEWLINE
	;



/*
	Polymorphic Range Predicate
*/

polymorphic_range_predicate   :  row_value_predicand  polymorphic_range_predicate_part_2  ;




		
polymorphic_range_predicate_part_2
	options {k=1;}
	:   ('NOT' {System.out.print("NOT ");})? 'BETWEEN'  {System.out.print(" BETWEEN ");} genomic_location_value  
	    'AND' {System.out.print("AND ");} genomic_location_value chromosome_clause (map_clause)? (reference_polymorphism_clause)?
	
	    ;
	 
genomic_location_value	: row_value_predicand ('KB' {System.out.print(" KB ");}  | 'LOCUS' {System.out.print("LOCUS ");} 
		| 'MARKER' {System.out.print("MARKER ");} | 'AGI CLONE' {System.out.print("AGI CLONE ");} 
		| 'OTHER CLONE' {System.out.print("OTHER CLONE ");})+;
//genomic_location_value	: row_value_predicand Map_Unit;

chromosome_clause	: 'ON' {System.out.print("ON ");} 'CHROMOSOME' {System.out.print("CHROMOSOME ");} chromosome_value_predicand;

chromosome_value_predicand	      : row_value_predicand;

map_clause		:   'ON' {System.out.print("ON ");} 'MAP' {System.out.print("MAP ");} map_value_predicand;

map_value_predicand	:  row_value_predicand;

reference_polymorphism_clause	:  'USING' {System.out.print(" USING ");} 'REFERENCE' {System.out.print("REFERENCE ");} 
			(one=Single_Quote {System.out.print($one.text);})? row_value_predicand (two=Single_Quote  {System.out.print($two.text);})?;

/*
reference_polymorphism_clause	:  'USING' {System.out.print(" USING ");} 'REFERENCE' {System.out.print("REFERENCE ");} 
			(one=Single_Quote {System.out.print($one.text);})? col_literal (two=Single_Quote  {System.out.print($two.text);})?;
*/
/*
	Ontology Child Predicate
*/
/*
boolean_and_ontology_predicate: boolean_and_ontology_expression;
boolean_and_ontology_expression  :	 boolean_term2 ('OR' ontology_child_predicate)*;
boolean_term2 :   		boolean_factor2 ('AND' ontology_child_predicate)+;
*/
/*
ontology_child_predicate 
	:   term_value_expression child_predicate_part_2;
*/
ontology_child_predicate 
	:   row_value_special_case child_predicate_part_2;
child_predicate_part_2
	:  ontology_relation  term_value_expression ontology_clause;
	
ontology_relation
	: ('IS-A' {System.out.print(" IS-A");} | 'PART-OF' {System.out.print(" PART-OF ");} | 'REGULATES' {System.out.print(" REGULATES ");})+ ;
	
/*
term_value_expression
	:  (Single_Quote)? string_value_expression (Single_Quote)?;
*/
term_value_expression
@init   {

	//int counter = 0;
	int counter2 = 0;
	int beginone = 0;
	int wcounter = 0;
	Mark marker = new Mark();	
	//StringBuffer z = new StringBuffer();
	StringBuffer n = new StringBuffer();
	//StringBuffer zz = new StringBuffer();
	
}
	:  (one=Single_Quote {System.out.print(" " + $one.text);} )? (e=non_terminal_identifier {
		
		counter2 = counter2 + 1; 
		Integer k = new Integer(counter2);
		memory2.put(k , $e.value);
	
	})* { for ( int j = 1; j <= counter2 ; j++) {
	      if ( j == 1) {
                             	String m = (String) memory2.get(j);
                           	n.insert(0, m);
                             }
                             else
                             	{ 
                             	 	String m = (String) memory2.get(j);
                        		n.append(" ");
                             		n.append(m);
                             }

	}   
	System.out.print(n.toString());} 
	 (two=Single_Quote {System.out.print($two.text);})? {System.out.print(" ");};

ontology_clause 
	: 'IN' {System.out.print("IN");}  'ONTOLOGY' {System.out.print(" " + "ONTOLOGY" + " ");} 
	  (threequote=Single_Quote {System.out.print($threequote.text);})? ontology_value_expression (fourquote=Single_Quote {System.out.print($fourquote.text);})? 
	  ('EXCLUSIVE' {System.out.print(" " + "EXCLUSIVE" + " ");} | 'INCLUSIVE' {System.out.print(" " + "INCLUSIVE" + " ");})+;
	
ontology_value_expression 
	:  string_value_expression;	

/*
		 10.7 collate_clause  (p500)


Specify a default collating sequence.
*/

collate_clause   :  'COLLATE' fully_qualified_identifier ;

/*
		 10.9 aggregate_function  (p503)


Specify a value computed from a collection of rows.
*/

aggregate_function
	options{k=1;}
	:	'COUNT' Left_Paren Asterisk Right_Paren ( filter_clause  )?
	|	general_set_function  ( filter_clause  )?
	//|	binary_set_function   ( filter_clause  )?
	//|	ordered_set_function  ( filter_clause  )?
	;

general_set_function
	options{k=1;}
	:  set_function_type  Left_Paren ( set_quantifier  )? value_expression  Right_Paren;

set_function_type   :  computational_operation ;

computational_operation  :
		'AVG' | 'MAX' | 'MIN' | 'SUM'
	|	'EVERY' | 'ANY' | 'SOME'
	|	'COUNT'
	|	'STDDEV_POP' | 'STDDEV_SAMP' | 'VAR_SAMP' | 'VAR_POP'
	|	'COLLECT' | 'FUSION' | 'INTERSECTION'
	;

//set_quantifier   :  'DISTINCT' | 'ALL';


filter_clause   :  'FILTER' Left_Paren 'WHERE' search_condition  Right_Paren;

/*
binary_set_function
	options{k=1;}
	:	binary_set_function_type
		Left_Paren dependent_variable_expression  Comma independent_variable_expression  Right_Paren;

binary_set_function_type  :
		COVAR_POP | COVAR_SAMP | CORR | REGR_SLOPE
	|	REGR_INTERCEPT | REGR_COUNT | REGR_R2 | REGR_AVGX | REGR_AVGY
	|	REGR_SXX | REGR_SYY | REGR_SXY
	;

dependent_variable_expression   :  numeric_value_expression ;

independent_variable_expression   :  numeric_value_expression ;

ordered_set_function
	options{k=1;}
	:	hypothetical_set_function
	|	inverse_distribution_function ;

hypothetical_set_function   :
		rank_function_type
		Left_Paren hypothetical_set_function_value_expression_list  Right_Paren
		within_group_specification ;

within_group_specification   :  WITHIN GROUP Left_Paren ORDER BY sort_specification_list  Right_Paren;

hypothetical_set_function_value_expression_list   :  value_expression  ( Comma value_expression  )*;

inverse_distribution_function   :
		inverse_distribution_function_type
		Left_Paren inverse_distribution_function_argument
		Right_Paren within_group_specification ;

inverse_distribution_function_argument  :  numeric_value_expression ;

inverse_distribution_function_type   :  PERCENTILE_CONT | PERCENTILE_DISC;

*/

/*
		 10.10 sort_specification_list  (p515)


Specify a sort order.
*/

sort_specification_list   :  sort_specification  ( Comma sort_specification  )*;

sort_specification   :  sort_key  ( ordering_specification  )? ( null_ordering  )?;

sort_key   :  value_expression ;

ordering_specification   :  'ASC' | 'DESC';

null_ordering   :  'NULLS' 'FIRST' | 'NULLS' 'LAST';


non_terminal_identifier	returns [String value]:	Regular_Identifier {$value = $Regular_Identifier.text;};

/*
     Lexer Rule
     
*/

Equals_Operator         
	:	 '=';

Not_Equals_Operator     
	:	 '<>';

Less_Than_Operator      
	:	 '<';

Greater_Than_Operator   
	:	 '>';

Less_Or_Equals_Operator 
	:	 '<=';

Greater_Or_Equals_Operator  
	:	 '>=';

Unsigned_Integer	: ( '1'..'9' ) ( Digit )* ;

Unsigned_Integer2	: ( '0'..'9' ) ( Digit )* ;

fragment
Digit  :  '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9';

Regular_Identifier  :  SQL92_Identifier ;

fragment
SQL92_Identifier  :  SQL92_Identifier_Start ( SQL92_Identifier_Part )*;
fragment
SQL92_Identifier_Start  :  Simple_Latin_Letter|Percent|Digit;
fragment
//SQL92_Identifier_Part  :  Simple_Latin_Letter | Underscore|Percent | Dash | Digit;
SQL92_Identifier_Part  :  Simple_Latin_Letter | Underscore|Percent  | Digit;
fragment
Simple_Latin_Letter  :  Simple_Latin_Upper_Case_Letter | Simple_Latin_Lower_Case_Letter;

fragment
Simple_Latin_Upper_Case_Letter :
		'A' | 'B' | 'C' | 'D' | 'E' | 'F' | 'G' | 'H' | 'I' | 'J' | 'K' | 'L' | 'M' | 
		'N' | 'O' | 'P' | 'Q' | 'R' | 'S' | 'T' | 'U' | 'V' | 'W' | 'X' | 'Y' | 'Z';
		
fragment
Simple_Latin_Lower_Case_Letter :
		'a' | 'b' | 'c' | 'd' | 'e' | 'f' | 'g' | 'h' | 'i' | 'j' | 'k' | 'l' | 'm' | 
		'n' | 'o' | 'p' | 'q' | 'r' | 's' | 't' | 'u' | 'v' | 'w' | 'x' | 'y' | 'z';
		
fragment
Underscore	: '_';
fragment
Dash	:	'-';
fragment
Percent                 
	:'\%';

Left_Paren              :	 '(';
Right_Paren            :	 ')';
	
Comma                   
	:	 ',';

Asterisk                
	:	 '*';

Concatenation_Operator  
	:	 '\|\|';
Period                  
	:	 '.';



Right_Arrow             
	:	 '->';
	
Plus_Sign               
	:	 '+';
Minus_Sign              
	:	 '-';
Slash                   
	:	 '/';
	
Quote                   
	:	 '\\';
/*
Space
    :    ' '
    ;
*/	
Single_Quote	: '\'';

/*
Character_String_Literal :
		  Quote ( Extended_Latin_Without_Quotes  )* Quote ( Quote ( Extended_Latin_Without_Quotes  )* Quote )*
		;
*/
// Unicode Character Ranges
fragment
Extended_Latin_Without_Quotes       :   '\u0001' .. '!' | '#' .. '&' | '(' .. '\u00FF';

//Basic_Latin_Without_Quotes          :   ' ' .. '!' | '#' .. '&' | '(' .. '~';
Basic_Latin_Without_Quotes          :   '#' .. '&';

NEWLINE	:	'\r'? {skip();} '\n' {skip();};

WS
    : (' '|'\t'|'\n'|'\r')+ {skip();}
    ;
