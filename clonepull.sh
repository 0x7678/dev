#!/bin/bash
#
# Copyright 2014 Range Networks, Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# See the COPYING file in the main directory for details.
#

sayAndDo () {
	echo $@
	eval $@
	if [ $? -ne 0 ]; then
		echo "# ERROR: command failed!"
		exit 1
	fi
}

cloneOrPull () {
	if [ ! -d $@ ]; then
		echo "# cloning $@"
		sayAndDo git clone --recursive git@github.com:RangeNetworks/$@.git
		sayAndDo cd $@
		sayAndDo git submodule foreach 'git checkout master'
		sayAndDo cd ..
	else
		echo "# pulling $@"
		sayAndDo cd $@
		sayAndDo git pull
		sayAndDo git submodule update --remote
		sayAndDo git submodule foreach 'git checkout master'
		sayAndDo git submodule foreach 'git pull'
		sayAndDo cd ..
	fi
}

for component in a53 CommonLibs openbts RRLP smqueue sqlite3 subscriberRegistry
do
	cloneOrPull $component
done
