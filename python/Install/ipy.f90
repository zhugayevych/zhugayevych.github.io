! For a given IPython notebook, ipy launches browser and open the folder containing that notebook
!
! Andriy Zhugayevych, azh@ukr.net, www.zhugayevych.me
! created 20.08.2014, modified 21.08.2014

program ipy
implicit none
integer :: count,i,i1,i2
character(255) :: filename,browser

count=command_argument_count()
select case (count)
case (1)
 call get_command_argument(1,filename)
 browser="iexplore"
case (2)
 call get_command_argument(1,filename)
 call get_command_argument(2,browser)
case default
 print *,"Wrong arguments, usage:"
 print *," ipy filename [browser]"
 print *,"Shortcuts for browser: iexplore (default), firefox"
 call exit()
 end select

if (browser=="iexplore") then
 browser="C:\Program Files (x86)\Internet Explorer\iexplore.exe"
 end if
if (browser=="firefox") then
 browser="C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
 end if

do i=1,len(filename)
 if (filename(i:i)=="\") then
  filename(i:i)="/"
  end if
 end do

if (filename(1:12)=="C:/Users/azh") then
 i1=13
else
 i1=1
 end if
i2=index(filename,"/",.TRUE.)

call system('start "" "'//browser//'" http://localhost:8888/tree'//filename(i1:i2))

end
