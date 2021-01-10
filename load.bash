cat move_list_item.lua |
  sed    's/--.*$//g'         | # replace comments
  sed -E 's/"/\\"/g'          | # replace double quotes
  tr     '\n' ' '             | # replace new lines with ;
  sed -E 's/^/SCRIPT LOAD "/' | # add SCRIPT LOAD "
  sed -E 's/$/"\n/'           | # add ending "
  redis-cli
  