# -*- shell-script -*-
# Debugger load SCRIPT command.
#
#   Copyright (C) 2002-2006, 2008, 2010-2011, 2018-2019 Rocky
#   Bernstein <rocky@gnu.org>
#
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation; either version 2, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#   General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; see the file COPYING.  If not, write to
#   the Free Software Foundation, 59 Temple Place, Suite 330, Boston,
#   MA 02111 USA.

_Dbg_help_add load \
'**load** *bash-script*

Read in lines of a *bash-script*.

For paths with space characters please use octal escape, e.g.:
load /some/path\\0400with\\0400spaces/script.sh

See also:
---------
**info files**
'

_Dbg_do_load() {

  if (( $# != 1 )) ; then
    _Dbg_errmsg "Expecting one filename parameter, Got $#."
    return 1
  fi

  typeset _Dbg_filename="$(_Dbg_unescape_arg "$1")"
  typeset _Dbg_full_filename
  _Dbg_full_filename="$(_Dbg_resolve_expand_filename "$_Dbg_filename")"
  if [ -n "$_Dbg_full_filename" ] && [ -r "$_Dbg_full_filename" ] ; then
    # Have we already loaded in this file?
    typeset _Dbg_file
    for _Dbg_file in "${_Dbg_filenames[@]}" ; do
       if [[ "$_Dbg_file" == "$_Dbg_full_filename" ]] ; then
         _Dbg_msg "File $_Dbg_full_filename already loaded."
	 return 2
       fi
    done

    _Dbg_readin "$_Dbg_full_filename"
    _Dbg_msg "File $_Dbg_full_filename loaded."
  else
      _Dbg_errmsg "Couldn't resolve or read $_Dbg_filename"
      return 3
  fi
  return 0
}
