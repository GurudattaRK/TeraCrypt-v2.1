# TeraCrypt-v2.0
#### _What's faster than an assembly program? Multithreaded Assembly! To be specific Multicore Assembly._


Use this application to keep your files safe by encrypting them with a secure encryption algorithm with a blazingly fast execution! 
Just select your file and enter your password & thats it . Also don't worry about your files as it only creates an encrypted copy of your file & your file will be safe and untouched.

## How to use it?
As long as you have an INTEL or AMD CPU (x64 CPU) in your system  this program should work without any errors.
##### For WINDOWS users
- Just download the "TeraCrypt.exe" & you are ready to go! Once its downloaded , run it & you can start encrypting your files.
- Or you can run the "TeraCrypt_installer" to install application & then you are ready to go.
- If for some reason the TeraCrypt.exe & the installer don't work for you then you can try compiling the application using other files avalaible here. Just follow the steps mentioned below.
- You can either use the "C_sharedLib.so" or you can make one yourself by compiling the "C_sharedLib.s" file into a shared library using this command: 
- gcc -fPIC --shared -C C_sharedLib.s -o C_sharedLib.so 
- You might have to pip install some python modules like PyQt5,Tkinter etc. Install them if python prompts you to.
- Now you can directly run the python file (TeraCrypt.py) if you want .
- Or you can convert python file into an executable file too! To do that pip install & run "auto-py-to-exe".
- Once the auto-py-to-exe windows opens,In the script location section select the python file.
- Now choose "One file" option (by default "One directory" is selected). Next choose "window based" option(by default "console based" is selected).
- In additional files sections choose "add files" & add these 6 files one by one: C_sharedLib.so , shield.ico , eye_con.png , loading.gif , locked_file.png & unlocked_file.png .
- After you have added all files hit "convert .py to .exe" button & once its finshed click on the "open output folder" & you will find your executable file there.
#### For Linux users
- Just download the "TeraCrypt" & make sure you give it executable permissions & then run it & you can start encrypting your files.
- If for some reason the TeraCrypt doesn't work for you (or your distro) then you can try compiling the application using other files avalaible here. Just follow the steps mentioned below.
- You can either use the "C_sharedLib.so" or you can make one yourself by compiling the "C_sharedLib.s" file into a shared library using this command: 
- gcc -fPIC --shared -C C_sharedLib.s -o C_sharedLib.so -Wl,-Bsymbolic
- You might have to pip install some python modules like PyQt5,Tkinter etc. Install them if python prompts you to.
- Now you can directly run the python file (TeraCrypt.py) if you want .
- Or you can convert python file into an executable file too! To do that pip install & run "auto-py-to-exe".
- Once the auto-py-to-exe windows opens,In the script location section select the python file.
- Now choose "One file" option (by default "One directory" is selected). Next choose "window based" option.
- In additional files sections choose "add files" & add these 5 files one by one: C_sharedLib.so , shield.ico , eye_con.png , loading.gif , locked_file.png & unlocked_file.png .
- After you have added all files hit "convert .py to .exe" button & once its finshed click on the "open output folder" & you will find your executable file there.

p.s. After you run the applicaiton you can use the "verifyfiles.c" program to check if the files you have encrypted and decrypted and the original files used are same or not.
      It checks every bit of both files to make sure there were no corruptions during encryption and decryption process.

## About this project
This application detects how many physical cores your system has & utilizes each and every core to parallelize the encryption/decryption process. On each core an optimized x64 assembly program is running my encryption algorithm & processing your file in big chunks while communicating with front end written in python via a C wrapper. 

I do not take any responsibility for any files that get corrupted, damaged  or lost due this application.

You as a user would only see a very simple and easy to use interface which makes it easy to choose files for processing and also it gives the location of output files after processing is done. You can compare how well the application performed on your system  by checking the execution time and number of bytes processed that is being displayed at the bottom of the interface after the execution is done.

Feel free to share your execution times!. And as always if you see any bugs, crashes , improvements, etc contact me and give me a feedback :)
