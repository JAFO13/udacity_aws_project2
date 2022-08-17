# TODO: Define the output variable for the lambda function.
output "Udacity_Project2_Task5_Part2_lambda_arn" {
  description = "ARN of the Lambda script used for Udacity Project 2 Task 5 Part 2"
  value = aws_lambda_function.Udacity_project2_task5_function.arn
}