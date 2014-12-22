---
---

###

    daviga404.github.io Website
    Copyright (C) 2014 David Baxter

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


###

App = {

    settings: {

        # Speed of animations in milliseconds
        animSpeed: 500

    }

    actions: {

        # Performs scroll animation to
        # section of page indicated by
        # object's href (in format of #id)
        jumpTo: (elem) ->
            target = $ elem.href
            $('html, body').animate {
                scrollTop: target.offset().top
            }, App.settings.animSpeed

        jumpToTop: (elem) ->


    }

}

# Bind actions to elements with the data
# attribute data-action if there is an
# action defined for it.
$(document).delegate '[data-action]', 'click', (e) ->
    action = $(this).data 'action'
    if action in App.actions
        App.actions[action] this