program command_arg
integer :: i,n
character(len=10) :: arg1
character(len=10) :: arg2

call get_command_argument(1,arg1)
call get_command_argument(2,arg2)

read(arg1,*) i

i = i+1
print * ,arg1
print *, arg2
print *, i
end
