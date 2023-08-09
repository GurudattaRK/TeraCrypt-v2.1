## How to run it?
As long as you have an INTEL or AMD CPU (x64 CPU) in your system  this program should work without any errors.
##### There are 3 ways to run it:
#### 1. Direct install
- Easiest way is to just download the "TeraCrypt.exe" & you are ready to go! Once its downloaded , run it & you can start encrypting your files.
#### 2. Using installer
- More reliable and safe way is to download & run the "TeraCrypt_installer" to install application & then you are ready to go.
#### 3. Compiling the app yourself 
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
