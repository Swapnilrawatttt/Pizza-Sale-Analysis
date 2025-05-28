create database pizza_db ;

use pizza_db ;
select * from orders ;
select * from order_details ;
select * from pizzas ;
select * from pizza_types ;

#Questions:
#Basic

#Retrieve the total number of orders placed.
select count(distinct(order_id)) from orders ;

#Calculate the total revenue generated from pizza sales.
select sum(Total_cost) from 
(select ord.quantity,  piz.price, ord.quantity * piz.price as Total_cost
from order_details ord
inner join pizzas piz 
on ord.pizza_id = piz.pizza_id 
)
as NET_SUM;

#Identify the highest-priced pizza.
select * from pizzas 
order by price desc
limit 1;

#Identify the most common pizza size ordered.
select size, sum(quantity) as total_quantity from (
select pizzas.size, order_details.quantity
from order_details
inner join pizzas 
on pizzas.pizza_id = order_details.pizza_id ) as Common 
group by size 
order by total_quantity Desc limit 1;

#List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name , sum(order_details.quantity) as total_quantity 
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by total_quantity  DESC limit 5 ;

#Intermediate
#Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category , 
sum(order_details.quantity) as total_quantity
from order_details join pizzas 
on order_details.pizza_id = pizzas.pizza_id 
join pizza_types
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
group by category ;

#Determine the distribution of orders by hour of the day.
select hour(orders.time) , sum(order_details.quantity) as total_quantity
from orders 
join order_details
on orders.order_id = order_details.order_id 
group by hour(orders.time) order by hour(orders.time);

#Join relevant tables to find the category-wise distribution of pizzas.
select category ,count(distinct(name)) from pizza_types
group by category ;

#Group the orders by date and calculate the average number of pizzas ordered per day.
select orders.date , avg(order_details.quantity)
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.date ;

#Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name , sum(pizzas.price * order_details.quantity) as total_revenue 
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id 
group by pizza_types.name 
order by total_revenue desc limit 3; 

#Advanced
#Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.name , sum(pizzas.price * order_details.quantity) / 
(select sum(order_details.quantity * pizzas.price) as total 
from order_details join pizzas 
on order_details.pizza_id = pizzas.pizza_id)
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id 
group by pizza_types.name ;

