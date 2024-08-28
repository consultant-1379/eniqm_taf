#!/usr/bin/env python
"""
This script is used to mount the eniq on the VAPP
"""

import ftplib,fileinput,os,re,pwd,grp,time
filenames=['eniq.env','eniqevents.env']
path = '/ericsson/eniq/etc'
def main():
    print("\n\n\t\t\tWelcome to the ENIQ Mounting script")
    count =0
    for filename in filenames:
        if os.path.exists(os.path.join(path,filename)):
            count+=1
            if(filename=='eniq.env'):
                   filenames[0]=None
            if(filename=='eniqevents.env'):
                   filenames[0]=None
	    if(count==2):
                   print "\nAs the required eniq.env and eniqevents.env file exists on the path",path," hence moving to directory creation "
                   directoryCreation()
            
        else:
            fileExport()

def fileExport():
    print "As the files",filenames,"is/are not present under the path",path
    host='159.107.207.22'
    user='root'
    password='shroot'
    ftp=ftplib.FTP(host,user,password)
    dirPath="/ericsson/eniq/etc"
    ftp.cwd(dirPath)
    files =ftp.dir()
    for filename in filenames:
        if filename is not None:
	        local_filename=os.path.join(path,filename)
	        file=open(local_filename,'wb')
	        ftp.retrbinary('RETR '+filename,file.write)
	        print '\nCopying file '+filename+' ....'
	        file.close()
    ftp.quit()
    directoryCreation()

#create directory
def directoryCreation():
    path1="/ossrc/data"
    folders=["pmMediation"]
    subfolders=["eventData","pmData"]
    print "\nCreating directory ", folders," and subdirectories ",subfolders, " ..."
    for folder in folders:
        absolutePath=os.path.join(path1,folder)
        if not os.path.exists(absolutePath):
            os.makedirs(absolutePath)
        for subfolder in subfolders:
            pathForSubs=os.path.join(absolutePath,subfolder)
            if not os.path.exists(pathForSubs):
                os.makedirs(pathForSubs)
            uid = pwd.getpwnam("nmsadm").pw_uid
	    gid = grp.getgrnam("nms").gr_gid
	    os.chown(pathForSubs,uid,gid)
	print "\nCreated directory ", folders," and subdirectories ",subfolders, "!"
    parameterManupilation()

#change values in a file
def parameterManupilation():
    filepath=os.path.dirname("/etc/opt/ericsson/eniqm/")
    print "\nParameter manipulation in cxc.env file"
    if not os.path.exists(filepath):
        print "The path ", filepath," does not exist"
    Parameters={1:"RBS_RAX_LIC_FILE_REQ",2:"createSymbolicLinks_ENIQ_Events",3:"ENIQ_SON_VIS_Data",4:"LTE_GIS_Data",5:"ENIQ_IPRAN_Data",6:"UTRAN_GIS_Data",7:"RBS_DUW_FILE_REQ"}
    print "Below are the paramaters:- \n"
    for key,value in Parameters.items():
        print key,'   ',value
    indexs=[1,2,3,4,5,6,7]
    if not indexs:
        print "No index values are entered, hence no changes will be made..."
    else:
         with open(os.path.join(filepath,"cxc.env"),'r+') as file:
            lines=file.readlines()
            file.seek(0)
            for line in lines:
                for index in indexs:
                    if(index <=7 and index>0):
                        if(re.match(Parameters.get(index),line.encode("utf-8"))):
                            print "seting parameter ",Parameters.get(index)," to true"
			    line=line.replace("false","true")
                file.write(line)
    restartMC()
                            
#making changes to starteniqm.sh

def restartMC():
    startpath=os.path.dirname("/opt/ericsson/eniqm/bin/")
    print "\nChanging parameter RunAtStart to true in starteniqm.sh .."
    if not os.path.exists(startpath):
        print "The path ",startpath," does not exist"
    else:
        with open(os.path.join(startpath,"starteniqm.sh"),'r+') as file:
            lines =file.readlines()
            file.seek(0)
            for line in lines:
                if(re.match("-DEniqMRunAtStart",line.encode("utf-8").strip())):
                    print "yes we are reaching here"
                    line=line.replace("false","true")
                file.write(line)
	print "\nRestarting ENIQ-M MC Please wait ...."
    os.system('smtool online eniqm')
    os.system('smtool coldrestart eniqm -reason=other -reasontext=" "')
    print "\nENIQ-M MC restarted, Topolgy export will happen in next 3 mins, please be patient"
	time.sleep(180)
	print "\n ENIQM MOUNTING IS DONE"
	
#main program	
main()
