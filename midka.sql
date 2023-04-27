CREATE TABLE customer_ (
  customer_id NUMBER(5),
  first_last_name VARCHAR2(50),
  email VARCHAR2(50),
  phone_number NUMBER(8)
  );
  
  INSERT INTO customer_ (customer_id, first_last_name, email, phone_number)
  VALUES (1, 'John Smith', 'john@example.com', 12345678);

  INSERT INTO customer_ (customer_id, first_last_name, email, phone_number)
  VALUES (2, 'Jane Doe', 'jane@example.com', 98765432);
  
  CREATE TABLE payment_ (
  payment_id NUMBER(5),
  book_id NUMBER(10)
  );
  
  
  CREATE TABLE order_ (
  order_id NUMBER(5),
  customer_id NUMBER(10),
  order_date NUMBER(10),
  order_status VARCHAR(20)
  );
  
  CREATE TABLE shipping_ (
  order_id NUMBER(5),
  shipping_id NUMBER(5),
  shipping_date NUMBER(10),
  shipping_address VARCHAR(20)
  );
  
   CREATE TABLE book_ (
  book_id NUMBER(5),
  price NUMBER(5),
  author VARCHAR(20),
  title VARCHAR(20)
  );
  
  INSERT INTO book_ (book_id, price, author, title)
  VALUES (1, 10, 'John Doe', 'Book 1');
  
  INSERT INTO book_ (book_id, price, author, title)
  VALUES (2, 15, 'Jane Smith', 'Book 2');
  
  CREATE TABLE order_item_ (
  item_id NUMBER(5),
  order_id NUMBER(5),
  quantity NUMBER(10)
  );
  
  CREATE TABLE category_ (
  category_id NUMBER(5),
  category_name VARCHAR(20)
  );
  
  INSERT INTO category_ (category_id, category_name)
  VALUES (1, 'Category 1');

  INSERT INTO category_ (category_id, category_name)
  VALUES (2, 'Category 2');

DECLARE
  num_rows NUMBER;
  
  BEGIN
  -- Update the category_name for category_id = 1
  UPDATE category_
  SET category_name = 'New Category 1'
  WHERE category_id = 1;

 -- Get the row count into the num_rows variable
  num_rows := SQL%ROWCOUNT;
  
  -- Print the row count
  DBMS_OUTPUT.PUT_LINE('Number of rows updated: ' || num_rows);
  
  -- Delete the row with category_id = 2
  DELETE FROM category_
  WHERE category_id = 2;
  
   -- Get the row count into the num_rows variable
  num_rows := SQL%ROWCOUNT;

-- Print the row count
  DBMS_OUTPUT.PUT_LINE('Number of rows deleted: ' || num_rows);

  -- Insert a new row
  INSERT INTO category_ (category_id, category_name)
  VALUES (3, 'Category 3');

  -- Get the row count into the num_rows variable
  num_rows := SQL%ROWCOUNT;

  -- Print the row count
  DBMS_OUTPUT.PUT_LINE('Number of rows inserted: ' || num_rows);

END;

  CREATE OR REPLACE PROCEDURE calculate_payment AS
  
  v_customer_id customer_.customer_id%TYPE;
  v_first_last_name customer_.first_last_name%TYPE;
  v_email customer_.email%TYPE;
  v_phone_number customer_.phone_number%TYPE;
  v_total_payment NUMBER := 0;
  
  
  CURSOR c_customers IS
    SELECT customer_id, first_last_name, email, phone_number
    FROM customer_;
  
  
  CURSOR c_order_items (p_customer_id IN customer_.customer_id%TYPE) IS
    SELECT oi.order_id, oi.quantity
    FROM order_item_ oi
    WHERE oi.customer_id = p_customer_id;
    
    BEGIN
  
  FOR c_customer IN c_customers LOOP
    v_customer_id := c_customer.customer_id;
    v_first_last_name := c_customer.first_last_name;
    v_email := c_customer.email;
    v_phone_number := c_customer.phone_number;
    v_total_payment := 0;
    
    
    FOR c_order_item IN c_order_items(v_customer_id) LOOP
      
      v_total_payment := v_total_payment + c_order_item.quantity * get_item_price(c_order_item.order_id, c_order_item.item_id);
    END LOOP;
    
    
    DBMS_OUTPUT.PUT_LINE('Customer ID: ' || v_customer_id);
    DBMS_OUTPUT.PUT_LINE('First/Last Name: ' || v_first_last_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
    DBMS_OUTPUT.PUT_LINE('Phone Number: ' || v_phone_number);
    DBMS_OUTPUT.PUT_LINE('Total Payment: $' || v_total_payment);
    DBMS_OUTPUT.PUT_LINE('-----------------------------');
  END LOOP;
  
END calculate_payment;

CREATE OR REPLACE FUNCTION get_latest_shipping_date(p_order_id IN NUMBER)
RETURN DATE
IS
  v_shipping_date DATE;
BEGIN
  
  SELECT MAX(shipping_date) INTO v_shipping_date
  FROM shipping_
  WHERE order_id = p_order_id;
  
  RETURN v_shipping_date;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    
    DBMS_OUTPUT.PUT_LINE('No shipping data found for order_id: ' || p_order_id);
    RETURN NULL;
  WHEN OTHERS THEN
   
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    RETURN NULL;
END get_latest_shipping_date;

-- Create the user-defined exception
CREATE OR REPLACE EXCEPTION title_too_short
  EXCEPTION;
  
-- Create a trigger to check title length before inserting or updating
CREATE OR REPLACE TRIGGER check_title_length
BEFORE INSERT OR UPDATE ON book_
FOR EACH ROW
BEGIN
  IF LENGTH(:NEW.title) < 5 THEN
    RAISE title_too_short;
  END IF;
END;

CREATE OR REPLACE TRIGGER trg_payment
BEFORE INSERT ON payment_
FOR EACH ROW
DECLARE
  v_row_count NUMBER;
BEGIN
  -- Get the current number of rows in the table
  SELECT COUNT(*) INTO v_row_count FROM payment_;
  
  -- Display the current row count
  DBMS_OUTPUT.PUT_LINE('Current number of rows in the table: ' || v_row_count);
  
END;



  
  
  
