#gcc -fPIC --shared C_sharedLib.c -o C_sharedLib.so -Wl,-Bsymbolic
from PyQt5.QtWidgets import QApplication, QWidget, QLabel, QLineEdit, QPushButton, QVBoxLayout, QHBoxLayout
from PyQt5.QtGui import QFont, QIcon, QMovie, QPixmap
from tkinter import filedialog
from multiprocessing import *
from PyQt5.QtCore import Qt
from ctypes import *
from time import *
import threading
import hashlib
import fcntl                    # LINUX SPECIFIC
import sys
import os

def resource_path(relative_path):
    #Get absolute path to resource, works for dev and for PyInstaller
    try:
        # PyInstaller creates a temp folder and stores path in _MEIPASS
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    #print(os.path.join(base_path, relative_path))

    return os.path.join(base_path, relative_path)


def openfile1(result_list,label2):
    filepath1=filedialog.askopenfilename()
    label2.setText('File selected: '+str(filepath1))
    result_list[0]=str(filepath1)
    

def call(id,round,mod,blocksize,infile,outfile,key):

    print("python ID:",id)
    print("blocksize:",blocksize)
    print("round:",round)
    C_path= resource_path('C_sharedLib.so')
    lib = CDLL(C_path)

    # Define the C function prototype
    lib.main.argtypes = [c_int,c_ulonglong,c_int,c_char_p,c_char_p]
    lib.main.restype = None

    idt=c_int(id)
    rounds=c_ulonglong(round)
    mode=c_int(mod)


    try:
        inputfile = open(infile, "rb")
        outputfile = open(outfile, "r+b")
        
        inputfile.seek(id*blocksize) 
        content = inputfile.read(blocksize)

        lib.main(idt,rounds,mode,content,key)

        fcntl.flock(outputfile, fcntl.LOCK_EX)                           # LINUX SPECIFIC!!

        outputfile.seek(id*blocksize)

        outputfile.write(content)

        # Release the lock
        fcntl.flock(outputfile, fcntl.LOCK_UN)                           # LINUX SPECIFIC!!


        # Close the file
        inputfile.close()
        outputfile.close()
    except PermissionError:
        print("Process",id,"waiting for write permissions")
        print("\n")
    except OSError as e:
        print("Error code:",e,"in process:",id)
        print("\n")


def aux(password, mode, result_list, label4, label5, label6, main_window):

    label4.hide()
    #main_window.show_finished_image(69)
    label5.setText("Processing your file...")
    label6.setText("")

    cores = cpu_count()
    print("Logical cores:",cores)
    cores = cores//2
    if (cores < 1):
        cores = 1
    else:
        pass
    print("Actual cores:",cores)
    
    print(str(password))

    hashv= hashlib.sha3_512(str(password).encode("utf-8"))
    c = hashv.digest()
    hashv= hashlib.sha3_512(str(c).encode("utf-8"))
    d = hashv.digest()
    c = c + d
    keys = c
    
    print(c.hex())
    # label3.config(text="hash: "+str(c.hex()))
    

    inputf = result_list[0]

    if(mode == 0):
        output= inputf + ".lock"
    else:
        # Remove the extension from the path
        #output = os.path.splitext(inputf)[0]
        # Check if the extension is "lock" and remove it
        if inputf.endswith(".lock"):
            output = inputf[:-5]
            output_name = os.path.splitext(output)[0]
            ouput_ext=os.path.splitext(output)[1]
            output=output_name + "_unlocked" + ouput_ext
        else:
            output = inputf
            output_name = os.path.splitext(output)[0]
            ouput_ext=os.path.splitext(output)[1]
            output=output_name + "_unlocked" + ouput_ext

    outputfile = open(output, "wb")
    outputfile.close()

    file_stat = os.stat(inputf)
    filesize= file_stat.st_size
    OGfilesize = filesize

    print("file size:",filesize)

    h= filesize%128
    if(h != 0):
        v = 128-h
        filesize = filesize+v
        OGfilesize = filesize
    print("truncated file size:",filesize)

    residue=0

    start= time()

    if ((filesize <= 10485760) or (filesize <= cores*128) ):

        print("Start single core execution:")

        cores = 1
        roundz = filesize//128

        C_path= resource_path('C_sharedLib.so')
        lib = CDLL(C_path)
        # Define the C function prototype
        lib.main.argtypes = [c_int,c_ulonglong,c_int,c_char_p,c_char_p]
        lib.main.restype = None

        idt=c_int(420)
        roundx=c_ulonglong(roundz)
        mod=c_int(mode)


        inputfile = open(inputf, "rb")
        outputfile = open(output, "r+b")


        content = inputfile.read(filesize)
        x=(len(content)) % 128
        if(x != 0):
            y= 128-x
            content += b'\0' * y
            
        print("buffer length:",len(content))

        lib.main(idt,roundx,mod,content,keys)

        outputfile.write(content)

        inputfile.close()
        outputfile.close()

    else:
        residue= filesize % (128*cores)
        if(residue == 0):
            roundy= filesize // (128*cores)
        else:
            filesize = filesize - residue
            roundy= filesize // (128*cores)


        blocksize=  filesize//cores
        keys= c


        print("Starting ",cores,"core execution:")

        processes = []
        for i in range(cores):
            p = Process(target= call, args=(i,roundy,mode,blocksize,inputf,output,keys))
            p.start()
            processes.append(p)

        # Wait for child processes to finish
        for p in processes:
            p.join()

        # After processing of all cores

        if((residue !=0) and (cores > 1)):

            roundz = residue // 128
            offset = OGfilesize - residue

            C_path= resource_path('C_sharedLib.so')
            lib = CDLL(C_path)
            # Define the C function prototype
            lib.main.argtypes = [c_int,c_ulonglong,c_int,c_char_p,c_char_p]
            lib.main.restype = None

            idt=c_int(69)
            roundx=c_ulonglong(roundz)
            mod=c_int(mode)

        
            inputfile = open(inputf, "rb")
            outputfile = open(output, "r+b")


            inputfile.seek(offset) 
            content = inputfile.read(residue)
            x=(len(content)) % 128
            if(x != 0):
                y= 128-x
                content += b'\0' * y
                
            print("buffer length:",len(content))

            lib.main(idt,roundx,mod,content,keys)

            outputfile.seek(offset)
            outputfile.write(content)

            inputfile.close()
            outputfile.close()

        
    # dll.writer(struct_addr,filename2,size,mode)'
    #remove('./sync.syncx')
    end_time = time()
    execution_time = end_time - start
    

    if(mode ==0):
        main_window.show_finished_image(0)
        msg1 ="Encrypted file's location:\n"+str(output)
        msg2 ="Encrypted "+ str(OGfilesize) +" bytes in "+str(execution_time) + " seconds"

    else:
        main_window.show_finished_image(1)
        msg1 ="Decrypted file's location:\n"+str(output)
        msg2 ="Decrypted "+ str(OGfilesize) +" bytes in "+str(execution_time) + " seconds"

    label5.setText(msg1)
    label5.setAlignment(Qt.AlignCenter)
    label6.setText(msg2)

    if(mode==0):
        print(OGfilesize,"bytes Encrypted in\n",execution_time, "seconds.\n Encrypted file is saved at :\n",output)
    else:
        print(OGfilesize,"bytes Decrypted in\n",execution_time," seconds.\n Decrypted file is saved at :\n",output)
    return


class MyWidget(QWidget):

    def start_aux_thread(self,mode):
        self.loading_movie = QMovie(resource_path('loading.gif'))
        self.loading_label = QLabel(self)
        self.loading_label.setMovie(self.loading_movie)
        self.loading_label.setAlignment(Qt.AlignCenter)
        self.loading_movie.start()
        self.label4.setText("")  # Clear any previous messages
        self.layout().insertWidget(8, self.loading_label)  # Insert the loading label just before label4

        password = self.password_field.text()
        self.password_field.clear()

        thread = threading.Thread(target=aux, args=(password, mode, result_list, self.label4, self.label5, self.label6, self))
        thread.start()
    
    def show_finished_image(self,mode):
        # Hide the loading label
        self.loading_label.hide()
        self.label4.show()
        finished_image_path1 = resource_path('locked_file.png')

        finished_image_path2 = resource_path('unlocked_file.png')

        # Load and set the finished image
        if(mode == 0):
            pixmap = QPixmap(finished_image_path1)

        else:
            pixmap = QPixmap(finished_image_path2)
        
        self.label4.setText("")  # Clear any previous messages
        self.label4.setPixmap(pixmap)
        self.label4.setAlignment(Qt.AlignCenter)

    def toggle_password_visibility(self):
        if self.password_field.echoMode() == QLineEdit.Password:
            self.password_field.setEchoMode(QLineEdit.Normal)
        else:
            self.password_field.setEchoMode(QLineEdit.Password)


    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):

        try:
            icon_path= resource_path('shield.ico')
            self.setWindowIcon(QIcon(icon_path))
        except:
            print("Icon file named shield.ico not found")

        label1 = QLabel('Select the file you want to Encrypt/Decrypt')
        label1.setStyleSheet("color: #02013D; font-weight: bold;")
        label1.setFont(QFont("Calibri", 18))

        button1 = QPushButton('Select file here')
        button1.setStyleSheet("background-color: #3498DB; color: white; padding: 10px; border-radius: 5px;")
        button1.setFont(QFont("Calibri", 15, QFont.Bold))
        button1.clicked.connect(lambda:openfile1(result_list, self.label2))

        self.label2 = QLabel('')
        self.label2.setStyleSheet("color: #444444; font-weight: bold;")

        label3 = QLabel('Enter your password:')
        label3.setStyleSheet("color: #02013D; font-weight: bold;")
        label3.setFont(QFont("Calibri", 15))
        
        self.label4 = QLabel('')
        self.label4.setStyleSheet("color: #222222; font-weight: bold;")
        self.label4.setFont(QFont("Calibri", 14))

        self.label5 = QLabel('')
        self.label5.setStyleSheet("color: #444444; font-weight: bold;")
        self.label5.setFont(QFont("Calibri", 14))

        self.label6 = QLabel('')
        self.label6.setStyleSheet("color: #666666; font-weight: bold;")
        self.label6.setFont(QFont("Calibri", 12))

        self.password_field = QLineEdit()
        self.password_field.setEchoMode(QLineEdit.Password)  # Set the echo mode to Password for masked input
        self.password_field.setStyleSheet("background-color: #F0F0F0; border: 1px solid #BFBFBF; padding: 10px; border-radius: 5px;")
        self.password_field.setFont(QFont("Calibri", 12))

        self.show_password_button = QPushButton()
        eye_con = resource_path('eye_con.png')
        self.show_password_button.setIcon(QIcon(eye_con))
        self.show_password_button.clicked.connect(self.toggle_password_visibility)
        
        
        button2 = QPushButton('Encrypt')
        button2.setStyleSheet("background-color: #0fee5b; color: white; padding: 10px; border-radius: 5px;")
        button2.setFont(QFont("Calibri", 15, QFont.Bold))
        button2.clicked.connect(lambda _: self.start_aux_thread(0))

        button3 = QPushButton('Decrypt')
        button3.setStyleSheet("background-color: #E74C3C; color: white; padding: 10px; border-radius: 5px;")
        button3.setFont(QFont("Calibri", 15, QFont.Bold))
        button3.clicked.connect(lambda _: self.start_aux_thread(1))

        vbox = QVBoxLayout()
        hbox = QHBoxLayout()
        hbox2 = QHBoxLayout()

        vbox.addWidget(label1)
        vbox.addWidget(button1)
        vbox.addWidget(self.label2)
        vbox.addWidget(label3)
        vbox.addLayout(hbox)
        hbox.addWidget(self.password_field)
        hbox.addWidget(self.show_password_button)
        vbox.addLayout(hbox2)

        hbox2.addWidget(button2)
        hbox2.addWidget(button3)
        vbox.addWidget(self.label4)
        vbox.addWidget(self.label5)
        vbox.addWidget(self.label6)
        vbox.setSpacing(20)
        vbox.setContentsMargins(20, 20, 20, 20)

        self.setLayout(vbox)


if __name__ == '__main__':
    freeze_support()
    global result_list
    result_list=[2]
    app = QApplication(sys.argv)
    widget = MyWidget()
    widget.resize(400, 300)  # Set the width to 400 pixels and height to 300 pixels
    widget.setWindowTitle("TeraCrypt v2.0")
    widget.show()
    sys.exit(app.exec_())

