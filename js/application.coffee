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
        animSpeed: 700

        # Easing function to use in animations
        animEasing: 'easeInOutCubic'

    }

    actions: {

        # Performs scroll animation to
        # section of page indicated by
        # object's href (in format of #id)
        jumpTo: (elem, target) ->
            target = $ target

            if target.length != 1
                return

            $('html, body').animate {
                scrollTop: target.offset().top
            }, {
                duration: App.settings.animSpeed
                easing:   App.settings.animEasing
            }

        # Performs scroll animation to
        # the top of the page
        jumpToTop: (elem) ->
            $('html, body').animate {
                scrollTop: 0
            }, {
                duration: App.settings.animSpeed
                easing:   App.settings.animEasing
            }

        # Toggles a class `clazz` on element
        # `target`.
        toggleClass: (elem, target, clazz) ->
            $target = $ target

            if $target.length < 1
                return

            $target.toggleClass clazz

    }

    effects: {

        # Parallax scrolling effect!
        parallax: (elem) ->
            $elem = $ elem
            $(window).scroll ->
                elemTop    = $elem.offset().top
                elemHeight = $elem.outerHeight()
                scrollPos  = $(window).scrollTop()
                speed      = 0.5

                # Return if element is no longer in viewport
                if scrollPos > elemTop + elemHeight
                    return

                # Don't bother with mobile...
                if App.utils.isMobile()
                    return

                newPos = 50 + (Math.floor ((scrollPos * speed) / elemHeight) * 50)
                $elem.css 'backgroundPosition', "50% #{newPos}%"
                

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

        # Calls a function in the App namespace from an
        # element's attribute
        # elem          - The element to bind the function to
        # attributeName - Name of the data attribute (e.g. data-action = "action")
        # functionType  - The type of function in App namespace (e.g. App.actions = "actions")
        # callback      - A function to call if successful
        bindFunctions: (elem, attributeName, functionType, callback) ->
            funcAttr = ($(elem).data attributeName) || ''
            func     = App.utils.parseFunctionAttr funcAttr

            # Make sure attr was parsable
            if not func or func.length < 1
                return

            # Check whether function exists
            if App[functionType].hasOwnProperty func[0]
                App[functionType][func[0]] elem, func.slice(1)... # Splat!
                callback()

        # Tests if user is on a mobile device
        isMobile: ->
            /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test navigator.userAgent

    }

}


# Bind actions to elements with the data
# attribute data-action if there is an
# action defined for it.
$(document).delegate 'a[data-action]', 'click', (event) ->

    App.utils.bindFunctions this, 'action', 'actions', -> event.preventDefault()

$('*[data-effect]').each (i, v) ->

    App.utils.bindFunctions this, 'effect', 'effects', -> return
