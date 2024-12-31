! The frontmo utility extracts frontier molecular orbitals (MOs) from all-electron calculations.
! It takes evc- and s1e-files containing 'no' eigenvalues in basis of size 'N'
!  and calculates frontier MOs mo=evc(:,o1:o2), where o1=HOMO-nfo+1, o2=HOMO+nfo,
!  and their biorthogonal MOs moS=Transpose(mo)*S, such that moS*mo=1 of size 2*nfo,
!  saving them as binary evc- and evr-files, respectively.
! The evl-file will also be cut and saved as evl-file.
! Existing files are renamed with .bak extra-extension.
! All input and output binary files are formatted as described at https://cmsos.github.io/cmsos/bin
!
! Andriy Zhugayevych, azh@ukr.net, zhugayevych.me
! created 31.12.2024, modified 31.12.2024
!
! Requires implementation:
! - parameters and variables checkup
! - LAPACK detection
! - unpaired spins

program frontmo
implicit none
integer(4), parameter :: myid=1760568055, evccode=18221058, evlcode=16844802
integer(4) :: count, nfo, Na, Nb, o1, o2, no2, id, N, no, i, j, k, o, q
integer(1), dimension(4) :: cod
real(8) :: chksum
real(8), dimension(4) :: buffer
real(8), allocatable :: evc(:,:), mo(:,:), S(:,:), moS(:,:), chk(:,:), ev(:)
character(255) :: filename, outfile, evcfile, evrfile, evlfile, s1efile, t
logical :: uselapack

uselapack=.false.

! Check arguments
count=command_argument_count()
if (count==0) then
 print *,"Wrong arguments, usage:"
 print *," frontmo filename number_of_MO_per_band"
 print *,"The following files must exist:"
 print *," filename.out - Gaussian log-file to read number of electrons and optionally pop(orbitals=?),"
 print *," filename.evc - eigenvectors (all occupied MOs + enough number of virtual MOs),"
 print *," filename.evl - eigenvalues,"
 print *," filename.s1e - overlap matrix."
 call exit()
 end if

! Read and initialize filenames
call get_command_argument(1,filename)
outfile=trim(filename)//'.out'
evcfile=trim(filename)//'.evc'
evrfile=trim(filename)//'.evr'
evlfile=trim(filename)//'.evl'
s1efile=trim(filename)//'.s1e'

! Read nfo
if (count>1) then
  call get_command_argument(2,t)
  read(t,*) nfo
else
  open(unit=1,file=outfile,action='read',status='old')
  do
    read(1,'(A)') t
    i=index(t,'pop(orbitals=')
    if (i>0) then
      t=t(i+13:)
      do j=1,len(t)
        if (t(j:j)<'0' .or. t(j:j)>'9') exit
      end do
      read(t(:j-1),*) nfo
      exit
    end if
  end do
end if
print '(A,I3)',"nfo=",nfo
if (nfo<1) then
  print *,"No orbitals requested"
  call exit()
end if

! Read number of electrons and determine MO numbers
open(unit=1,file=outfile,action='read',status='old')
do
  read(1,'(A)') t
  i=index(t,'alpha electrons')
  if (i>0) then
    read(t(:i-1),*) Na
    read(t(i+15:),*) Nb
    exit
  end if
end do
close(1)
print '(A,I4,A,I4)',"Na=",Na,", Nb=",Nb
if (Na/=Nb) then
  print *,"Unpaired electrons are not supported"
  call exit()
end if
o1=Na-nfo+1
o2=Na+nfo
no2=2*nfo
print '(A,I4,A,I4)',"o1=",o1,", o2=",o2

! Read file description
open(unit=1,file=evcfile,form='unformatted',access='direct',action='read',status='old',recl=4)
read(1,rec=1) id
read(1,rec=3) N
read(1,rec=4) no
close(1)
if (id/=myid) then
  print *,"Unrecognized file type ID ",id
  call exit()
end if
open(unit=1,file=evcfile,form='unformatted',access='stream',action='read',status='old')
read(1) cod
read(1) cod
close(1)
print '(A,I2,A,I2,A,I2,A,I2,A)',"cod=[",cod(1),",",cod(2),",",cod(3),",",cod(4),"]"
print '(A,I5,A,I5)',"N=",N,", no=",no

! Read eigenvectors from evc-file and cut MOs
allocate(evc(N,no))
open(unit=1,file=evcfile,form='unformatted',access='stream',action='read',status='old')
read(1) buffer
read(1) evc
close(1)
allocate(mo(N,no2))
mo=evc(:,o1:o2)
deallocate(evc)

! Read overlaps from s1e-file
allocate(S(N,N))
open(unit=1,file=s1efile,form='unformatted',access='stream',action='read',status='old')
read(1) buffer
do i=1,N
  read(1) (S(i,j),j=1,i)
end do
close(1)
do i=1,N
  do j=i+1,N
    S(i,j)=S(j,i)
  end do
end do

! Calculate moS
allocate(moS(no2,N))
if (uselapack) then
!  call dgemm('T','N',no2,N,N,1,mo,N,S,N,0,moS,no2)
else
  moS=0.0
  do o=1,no2
    do i=1,N
      do k=1,N
        moS(o,i)=moS(o,i)+mo(k,o)*S(k,i)
      end do
    end do
  end do
end if
deallocate(S)

! Check biorthogonality
allocate(chk(no2,no2))
if (uselapack) then
!  call dgemm('N','N',no2,no2,N,1,moS,no2,mo,N,0,chk,no2)
else
  chk=0.0
  do o=1,no2
    do q=1,no2
      do k=1,N
        chk(o,q)=chk(o,q)+moS(o,k)*mo(k,q)
      end do
    end do
    chk(o,o)=chk(o,o)-1
  end do
end if
chksum=0.0
do o=1,no2
  do q=1,no2
     chksum=chksum+chk(o,q)**2
  end do
end do
chksum=sqrt(chksum)
print *,"evr.evc=",chksum
!do o=1,4
!  print '(4F6.3)',(chk(o,q),q=1,4)
!end do

! Read eigenvalues from evl-file
allocate(ev(no))
open(unit=1,file=evlfile,form='unformatted',access='stream',action='read',status='old')
read(1) buffer
read(1) ev
close(1)

! Write binaries
open(unit=2,file=evrfile,form='unformatted',access='stream',action='write',status='new')
write(2) myid,evccode,no2,N,0,0,0,0
write(2) moS
close(2)

call rename(evcfile,trim(evcfile)//'.bak')
open(unit=2,file=evcfile,form='unformatted',access='stream',action='write',status='new')
write(2) myid,evccode,N,no2,0,0,0,0
write(2) mo
close(2)

call rename(evlfile,trim(evlfile)//'.bak')
open(unit=2,file=evlfile,form='unformatted',access='stream',action='write',status='new')
write(2) myid,evlcode,no2,0,0,0,0,0
write(2) ev(o1:o2)
close(2)

call rename(s1efile,trim(s1efile)//'.bak')

end
