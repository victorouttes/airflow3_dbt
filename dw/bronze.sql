-- Create schema for dw_bronze layer
CREATE SCHEMA IF NOT EXISTS dw_bronze;

-- Customer source system table
CREATE TABLE IF NOT EXISTS dw_bronze.raw_customers
(
    record_id
    SERIAL
    PRIMARY
    KEY,
    source_system
    VARCHAR
(
    50
),
    raw_data JSONB,
    ingestion_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- Orders source system table
CREATE TABLE IF NOT EXISTS dw_bronze.raw_orders
(
    record_id
    SERIAL
    PRIMARY
    KEY,
    source_system
    VARCHAR
(
    50
),
    raw_data JSONB,
    ingestion_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- Products source system table
CREATE TABLE IF NOT EXISTS dw_bronze.raw_products
(
    record_id
    SERIAL
    PRIMARY
    KEY,
    source_system
    VARCHAR
(
    50
),
    raw_data JSONB,
    ingestion_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- Insert sample data into customers
INSERT INTO dw_bronze.raw_customers (source_system, raw_data)
VALUES ('CRM_SYSTEM',
        '{"customer_id": "C001", "name": "John Doe", "email": "john@example.com", "phone": "555-0101", "address": "123 Main St"}'::jsonb),
       ('CRM_SYSTEM',
        '{"customer_id": "C002", "name": "Jane Smith", "email": "jane@example.com", "phone": "555-0102", "address": "456 Oak Ave"}'::jsonb),
       ('LEGACY_SYSTEM',
        '{"customer_id": "L123", "full_name": "Bob Wilson", "contact": "bob@example.com", "tel": "555-0103"}'::jsonb);

-- Insert sample data into orders
INSERT INTO dw_bronze.raw_orders (source_system, raw_data)
VALUES ('ECOMMERCE',
        '{"order_id": "O001", "customer_id": "C001", "total": 99.99, "items": ["SKU001", "SKU002"], "status": "completed"}'::jsonb),
       ('ECOMMERCE',
        '{"order_id": "O002", "customer_id": "C002", "total": 150.50, "items": ["SKU003"], "status": "pending"}'::jsonb),
       ('POS_SYSTEM',
        '{"transaction_id": "T789", "cust_id": "L123", "amount": 75.25, "products": ["P1", "P2", "P3"]}'::jsonb);

-- Insert sample data into products
INSERT INTO dw_bronze.raw_products (source_system, raw_data)
VALUES ('INVENTORY_SYSTEM',
        '{"sku": "SKU001", "name": "Laptop", "price": 999.99, "category": "Electronics", "stock": 50}'::jsonb),
       ('INVENTORY_SYSTEM',
        '{"sku": "SKU002", "name": "Mouse", "price": 29.99, "category": "Electronics", "stock": 100}'::jsonb),
       ('SUPPLIER_PORTAL',
        '{"product_code": "P1", "product_name": "Desk Chair", "unit_cost": 199.99, "supplier_id": "S001"}'::jsonb);