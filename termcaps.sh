#!/usr/bin/env bash
# Generate termcaps from terminfo via tput to standard output in CSV
# Copyright (c) 2018 Yu-Jie Lin
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


DEFAULT_CAPNAMES='colors cup bold setaf'


main()
{
    local capnames=(${*:-$DEFAULT_CAPNAMES}) capname

    printf '"TERM"'
    for capname in "${capnames[@]}"; do
        printf ',"%s"' "$capname"
    done
    printf '\n'

    # https://wiki.archlinux.org/index.php/Color_output_in_console#Enumerate_supported_colors
    find /usr/share/terminfo -type f -printf '%f\n' |
    sort |
    while read T; do
        [[ $T == .* ]] && continue
        # use longname to test if $T exists in terminal database
        tput -T "$T" longname &>/dev/null || continue

        printf '"%s"' "$T"
        for capname in "${capnames[@]}"; do
            printf ',"%q"' "$(tput -T $T "$capname")"
        done
        printf '\n'
    done
}


main "$@"
