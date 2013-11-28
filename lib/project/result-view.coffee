{_, $, fs, View} = require 'atom'
MatchView = require './match-view'
path = require 'path'

module.exports =
class ResultView extends View
  @content: (filePath, matches) ->
    iconClass = if fs.isReadmePath(filePath) then 'icon-book' else 'icon-file-text'

    @li class: 'path list-nested-item', 'data-path': _.escapeAttribute(filePath), =>
      @div outlet: 'pathDetails', class: 'path-details list-item', =>
        @span class: 'disclosure-arrow'
        @span class: iconClass + ' icon'
        @span class: 'path-name bright', filePath.replace(atom.project.getPath()+path.sep, '')
        @span outlet: 'description', class: 'path-match-number'
      @ul outlet: 'matches', class: 'matches list-tree', =>

  initialize: (@filePath, result) ->
    @renderResult(result)

  renderResult: (result) ->
    selectedIndex = @matches.find('.selected').index()

    @matches.empty()

    if result
      @description.show().text("(#{matches?.length})")
    else
      @description.hide()

    matches = result?.data
    if not matches or matches.length == 0
      @hide()
    else
      @show()
      for match in matches
        @matches.append(new MatchView({@filePath, match}))

    @matches.children().eq(selectedIndex).addClass('selected') if selectedIndex > -1

  updateReplacementPattern: (regex, pattern) ->
    for matchView in @matches.children().views()
      matchView.updateReplacementPattern(regex, pattern)

  confirm: ->
    atom.workspaceView.openSingletonSync(@filePath, split: 'left')
