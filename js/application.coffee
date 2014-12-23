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

# App object to provide settings
# and actions for data-action links
App = {

    settings: {

        # Speed of animations in milliseconds (or jQuery string)
        animSpeed: 500

    }

    actions: {

        # Performs scroll animation to
        # section of page indicated by
        # object's href (in format of #id)
        jumpTo: (elem) ->
            target = $ elem.getAttribute 'href'

            if target.length != 1
                return

            $('html, body').animate {
                scrollTop: target.offset().top
            }, App.settings.animSpeed

        # Performs scroll animation to
        # the top of the page
        jumpToTop: (elem) ->
            $('html, body').animate {
                scrollTop: 0
            }, App.settings.animSpeed

        toggleClass: (elem, target, clazz) ->
            $target = $ target

            if $target.length < 1
                return

            $target.toggleClass clazz

    }

    utils: {

        # Parses a function attribute (attribute
        # in the form of func(args...)) to an
        # array - [function name, arguments...]
        parseFunctionAttr: (attr) ->
            if attr.match /^[a-zA-Z0-9]+$/
                [attr]
            else if attr.match /^[a-zA-Z0-9]+\((?:\s*[^, ]+\s*,)*(?:\s*[^, ]+\s*)\)$/
                funcName     = attr.substring 0, attr.indexOf('(')
                funcBrackets = attr.substring attr.indexOf('(') + 1, attr.lastIndexOf(')')
                funcArgs     = funcBrackets.split(',').map (v) -> v.trim()

                if not funcName or not funcBrackets or not funcArgs or funcArgs.length == 0
                    []
                else
                    [funcName].concat funcArgs

    }

}

# Bind actions to elements with the data
# attribute data-action if there is an
# action defined for it.
$(document).delegate 'a[data-action]', 'click', (event) ->

    action = $(this).data 'action'
    func   = App.utils.parseFunctionAttr(action)

    # Make sure attr was parsable
    if func.length < 1
        return

    # Check whether action exists
    if App.actions.hasOwnProperty func[0]
        event.preventDefault()
        App.actions[func[0]] this, func.slice(1)... # Splat!