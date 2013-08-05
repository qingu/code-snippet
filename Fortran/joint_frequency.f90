!*******************************************************************
!Author: Jiangqingu
!Date: 2013/8/5
!Purpose: 求每个格点每年的波高和风速联合频率
!Note: 程序只求了联合频率，存放在数组freq(SPD_RANGE,HGT_RANGE,YEARS,GRID_NUM)
!      没有IO输出文件，需要的话自行加上。需要事先用好压等软件批量修改读入文件名
!      去掉文件名中的中文
!*******************************************************************

program joint_frequency
implicit none

integer, parameter :: SPD_RANGE = 10
integer, parameter :: HGT_RANGE = 11
integer, parameter :: YEARS = 5
integer, parameter :: GRID_NUM = 332

logical,external :: isleap

integer :: NR,status,totalrecs
real,dimension(SPD_RANGE,HGT_RANGE,YEARS,GRID_NUM) ::freq
character(len=4) :: sID
character(len=40) :: wavename,windname
character(len=40) :: buffer
real,dimension(10) :: spd_l,spd_r
real,dimension(11) :: hgt_l,hgt_r
integer,allocatable,dimension(:) :: iyr
real,allocatable,dimension(:) :: dir,hgt,spd
integer :: count

integer :: i,j,k,kk,il,pyear

!风速范围区间spd_l~spd_r，波高范围区间hgt_l~hgt_r
data spd_l /0,2,3,4,5,6,7,8,9,10/
data spd_r /2,3,4,5,6,7,8,9,10,999/
data hgt_l /0.0,0.2,0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0/
data hgt_r /0.2,0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0,999/


freq = 0.
do kk=1, GRID_NUM
   !波浪要素及风要素文件名，事先使用好压软件把中文名批量修改为含数字、英文的
   !文件名，类似1-wave.txt,1-wind.txt
   write(sID,'(i3)') kk
   wavename = 'e:\data\2002-2006wave\'//trim(adjustl(sID))//'-wave.txt'
   windname = 'e:\data\2002-2006wind\'//trim(adjustl(sID))//'-wind.txt'
   !print *, wavename
   !print *, windname

   open(12,file=wavename)
   !获得文件行数,除掉第一行标题
   NR=0
   do while(.true.)
     read(unit=12,fmt="(A79)",iostat=status) buffer
     if(status/=0) exit
     NR=NR+1
   enddo
   NR=NR-1
   !print *,NR

   !读取位置返回文件开头
   rewind(12)
   
   allocate(iyr(NR))
   allocate(dir(NR))
   allocate(hgt(NR))
   allocate(spd(NR))

   !读取相应数据
   read(12,'(A79)') buffer
   do i=1,NR
     read(12,"(I4,16X,F7.3,2X,F6.3)") iyr(i),dir(i),hgt(i)
   enddo
   close(12)

   open(13,file=windname)

   read(13,*)
   do i=1,NR
     read(13,"(34X,F4.1)") spd(i)
   enddo
   close(13)
   !write(*,*) iyr(NR),hgt(NR),spd(NR)
   !年循环
   do k=1,5
     pyear=2001+k
     !判断闰年还是平年的记录总次数
     if(isleap(pyear)) then
         totalrecs = 366*8
     else
         totalrecs = 365*8
     endif
     !波高区间
     do j=1,11
       !风速区间
       do i=1,10
         count=0
         do il=1,NR
           if((pyear==iyr(il)).and.(hgt(il)>hgt_l(j)).and.(hgt(il)<=hgt_r(j)&
              .and.(spd(il)>spd_l(i)).and.(spd(il)<=spd_r(i)))) then
              count = count + 1
           endif
         enddo
         freq(i,j,k,kk)=count*1.0/totalrecs*100.0
       enddo
     enddo
   enddo
   
   deallocate(iyr)
   deallocate(dir)
   deallocate(hgt)
   deallocate(spd)

enddo
         
!输出第332个格点、2006年联合频率测试
do j=1,11
   write(*,'(10F6.3)') (freq(i,j,1,332),i=1,10)
enddo

end

logical function isleap(iyr)
    ! arguments
    integer, intent(in) :: iyr

    if (mod(iyr,400)==0) then
      isleap=.true.
    else if (mod(iyr,100)==0) then
      isleap=.false.
    else if (mod(iyr,4)==0) then
      isleap=.true.
    else
      isleap=.false.
    endif
    return
end function isleap

