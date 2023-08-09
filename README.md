# TeraCrypt-v2.0
#### _What's faster than an assembly program? Multithreaded Assembly! To be specific Multicore Assembly._

Use this application to keep your files safe by encrypting them with a secure encryption algorithm with a blazingly fast execution! 
Just select your file and enter your password & thats it . Also don't worry about your files as it only creates an encrypted copy of your file & your file will be safe and untouched.

## About this project
This application detects how many physical cores your system has & utilizes each and every core to parallelize the encryption/decryption process. On each core an optimized x64 assembly program is running my encryption algorithm & processing your file in big chunks while communicating with front end written in python via a C wrapper. 

You as a user would only see a very simple and easy to use interface which makes it easy to choose files for processing and also it gives the location of output files after processing is done. You can compare how well the application performed on your system  by checking the execution time and number of bytes processed that is being displayed at the bottom of the interface after the execution is done.

I do not take any responsibility for any files that get corrupted, damaged  or lost due this application.

Feel free to share your execution times!. And as always if you see any bugs, crashes , improvements, etc contact me and give me a feedback :)
