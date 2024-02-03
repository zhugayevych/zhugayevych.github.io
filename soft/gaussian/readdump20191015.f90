! The readdump utility extracts a record from Gaussian rwf-dump or checkpoint file and store it in a binary file.
! If the provided code is text, the binary file is formatted according to ReadBIN command from
!   Maple BasicTools or Python ReadWrite.py.
! See technical details in exam_rwf.mw Maple worksheet of MolMod package
!
! Andriy Zhugayevych, azh@ukr.net, www.zhugayevych.me
! created 17.08.2011, modified 15.10.2019
!
! Many thanks for detected bugs to: Chern Chuang

program readdump
implicit none
integer, parameter :: myid=1760568055
integer :: count, cod, isize, filesize, j, i, nrec, L, cod2, pos1, pos2, n, datapos, mycode, ndims, dims(2), na
real(8), parameter :: hartree2eV=27.2113956555172, bohr2A=0.529177257506917
real(8) :: r,c
character(255) :: dumpfile, outfile, code

! Read arguments
count=command_argument_count()
if (count/=3) then
 print *,"Wrong arguments, usage:"
 print *," readdump dumpfile outfile code"
 print *,"Examples of numerical codes (see Programmer's Reference):"
 print *," 522 - alpha and beta eigenvalues,"
 print *," 524/526 - alpha/beta eigenvectors real part, 525/527 - imaginary part,"
 print *," 603 - density matrices, 633 - transition density,"
 print *," 637 - NO eigenvalues and eigenvectors."
 print *,"Recognized text codes:"
 print *," s1e(514),  h1e(515), evl(522), evla(522), evlb(522),"
 print *," evc(524), evca(524), evcb(526), rho(528), rhoa(528), rhob(530),"
 print *," frc(584), frcc(585), coo(997)."
 call exit()
 end if
call get_command_argument(1,dumpfile)
call get_command_argument(2,outfile)
call get_command_argument(3,code)

! Process ext
datapos=4
select case (code)
case ("s1e")
 cod=514
case ("h1e")
 cod=515
case ("evl","evla","evlb")
 cod=522
case ("evc","evca")
 cod=524
case ("evcb")
 cod=526
case ("rho","rhoa")
 cod=528
case ("rhob")
 cod=530
case ("frc")
 cod=584
case ("frcc")
 cod=585
case ("coo")
 cod=997
case default
 read(code,*) cod
 datapos=0
 end select

! Determine integer size and find record
inquire(FILE=dumpfile,SIZE=filesize)
isize=2
do j=1,2
 isize=2*isize
 open(unit=1,file=dumpfile,form='unformatted',access='direct',action='read',status='old',recl=isize)
 read(1,rec=1) nrec
 read(1,rec=2) L
 if (nrec>0 .AND. nrec<1100 .AND. 8*L==filesize) then
  do i=1,nrec
   read(1,rec=4*i-3) cod2
   if (cod2==cod) exit
   end do
  if (i>nrec) then
   close(1)
   print *,"Cannot find record ",cod
   call exit()
   end if
  read(1,rec=4*i-2) pos1
  read(1,rec=4*i-1) pos2
  n=pos2-pos1
	close(1)
	exit
	end if
 close(1)
 end do
if (j>2) then
 print *,"Cannot determine integer size"
 call exit()
 end if

! Set parameters
c=1
select case (code)
case ("s1e","h1e","rho","rhoa","rhob")
 mycode=16975874
 ndims=1
 dims(1)=int((sqrt(8*n+1.)-1)/2)
case ("evl","evla","evlb")
 mycode=16844802
 ndims=1
 n=n/2
 dims(1)=n
 c=hartree2eV
case ("evc","evca","evcb")
 mycode=18221058
 ndims=2
 dims(1)=int(sqrt(n*1.))
 dims(2)=dims(1)
case ("frc")
 mycode=18221058
 ndims=2
 dims(1)=3
 dims(2)=n/6
 n=n/2
 c=hartree2eV/bohr2A
case ("frcc")
 mycode=16975874
 ndims=1
 dims(1)=int((sqrt(8*n+1.)-1)/2)
 c=hartree2eV/bohr2A**2
case ("coo")
 mycode=18221058
 ndims=2
 na=(n-20)/18-3
 dims(1)=3
 dims(2)=na
 pos1=pos1+20+2*(na+3)
 n=3*na
 c=bohr2A
 end select
if (code=="evlb") then
 pos1=pos1+n
 end if

! Read record and write it to file
open(unit=1,file=dumpfile,form='unformatted',access='direct',action='read',status='old',recl=8)
if (datapos==0) then
 open(unit=2,file=outfile,form='unformatted',access='direct',action='write',status='new',recl=8)
else
 open(unit=2,file=outfile,form='unformatted',access='direct',action='write',status='new',recl=4)
 write(2,rec=1) myid
 write(2,rec=2) mycode
 do i=1,ndims
  write(2,rec=2+i) dims(i)
  end do
 close(2)
 open(unit=2,file=outfile,form='unformatted',access='direct',action='write',status='old',recl=8)
 end if
do i=1,n
 read(1,rec=pos1+i) r
 write(2,rec=datapos+i) c*r
 end do
close(1)
close(2)

print *, "File ",trim(outfile)," contains ",n," records of type real(8)"

end
