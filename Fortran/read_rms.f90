!Author: Unknown

program read_rms 
 implicit none
 real,allocatable::a(:)
 integer i,j,tmp1,tmp2
 character::string
 character::lab

 open(1,file='E:\other\rms_d01_02_analysis.dat')
 
  do j=1,2
  read(1,'(a)')string

  end do
  print *,string
  stop
  allocate(a(10))
  open(2,file='E:\other\rms_a.txt')
  read(1,*)a
  write(2,200)a
  close(1)
  close(2)
200 format(10f13.8)
  deallocate(a)

  do i=3,15
	  tmp1=int(i/10)-int(i/100)*10
	  tmp2=int(i/1)-int(i/10)*10
	  lab=char(48+tmp1)//char(48+tmp2)
	  allocate(a(10))
	  open(1,file='E:\other\rms_d01_'//lab//'_analysis.dat')

	  do j=1,2
	      read(1,'(a)')string
	  end do

	  open(2,file='E:\other\rms_a.txt',position="append")
	  read(1,*)a
	  write(2,200)a
	  close(1)
	  close(2)
	  deallocate(a)
  end do
   end
