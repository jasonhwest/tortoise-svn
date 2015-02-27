{CompositeDisposable} = require "atom"

tortoiseSvn = (args, cwd) ->
  spawn = require("child_process").spawn
  command = atom.config.get("tortoise-svn.tortoisePath") + "/TortoiseProc.exe"
  options =
    cwd: cwd

  tProc = spawn(command, args, options)

  tProc.stdout.on "data", (data) ->
    console.log "stdout: " + data

  tProc.stderr.on "data", (data) ->
    console.log "stderr: " + data

  tProc.on "close", (code) ->
    console.log "child process exited with code " + code

resolveTreeSelection = ->
  if atom.packages.isPackageLoaded("tree-view")
    treeView = atom.packages.getLoadedPackage("tree-view")
    treeView = require(treeView.mainModulePath)
    serialView = treeView.serialize()
    serialView.selectedPath

resolveEditorFile = ->
  editor = atom.workspace.getActivePaneItem();

  return if !editor

  file = editor.buffer.file;
  return if !file

  file.path

blame = (currFile)->
  args = [
    "/command:blame"
    "/path:"+currFile
    "/startrev:1"
    "/endrev:-1"
  ]
  tortoiseSvn(args, path.dirname(currFile))

commit = (currFile)->
  tortoiseSvn(["/command:commit", "/path:"+currFile], path.dirname(currFile))

diff = (currFile)->
  tortoiseSvn(["/command:diff", "/path:"+currFile], path.dirname(currFile))

log = (currFile)->
  tortoiseSvn(["/command:log", "/path:."], path.dirname(currFile))

revert = (currFile)->
  tortoiseSvn(["/command:revert", "/path:"+currFile], path.dirname(currFile))

update = (currFile)->
  tortoiseSvn(["/command:update", "/path:"+currFile], path.dirname(currFile))

module.exports = TortoiseSvn =
  config:
    tortoisePath:
      title: "Tortoise SVN bin path"
      description: "The folder containing TortoiseProc.exe"
      type: "string"
      default: "C:/Program Files/TortoiseSVN/bin"

  activate: (state) ->
    atom.workspaceView.command "tortoise-svn:blameFromTreeView", => @blameFromTreeView()
    atom.workspaceView.command "tortoise-svn:blameFromEditor", => @blameFromEditor()

    atom.workspaceView.command "tortoise-svn:commitFromTreeView", => @commitFromTreeView()
    atom.workspaceView.command "tortoise-svn:commitFromEditor", => @commitFromEditor()

    atom.workspaceView.command "tortoise-svn:diffFromTreeView", => @diffFromTreeView()
    atom.workspaceView.command "tortoise-svn:diffFromEditor", => @diffFromEditor()

    atom.workspaceView.command "tortoise-svn:logFromTreeView", => @logFromTreeView()
    atom.workspaceView.command "tortoise-svn:logFromEditor", => @logFromEditor()

    atom.workspaceView.command "tortoise-svn:revertFromTreeView", => @revertFromTreeView()
    atom.workspaceView.command "tortoise-svn:revertFromEditor", => @revertFromEditor()

    atom.workspaceView.command "tortoise-svn:updateFromTreeView", => @updateFromTreeView()
    atom.workspaceView.command "tortoise-svn:updateFromEditor", => @updateFromEditor()

  blameFromTreeView: ->
    currFile = resolveTreeSelection()
    return if !currFile
    blame(currFile)

  blameFromEditor: ->
    currFile = resolveEditorFile()
    return if !currFile
    blame(currFile)

  commitFromTreeView: ->
    currFile = resolveTreeSelection()
    return if !currFile
    commit(currFile)

  commitFromEditor: ->
    currFile = resolveEditorFile()
    return if !currFile
    commit(currFile)

  diffFromTreeView: ->
    currFile = resolveTreeSelection()
    return if !currFile
    diff(currFile)

  diffFromEditor: ->
    currFile = resolveEditorFile()
    return if !currFile
    diff(currFile)

  logFromTreeView: ->
    currFile = resolveTreeSelection()
    return if !currFile
    log(currFile)

  logFromEditor: ->
    currFile = resolveEditorFile()
    return if !currFile
    log(currFile)

  revertFromTreeView: ->
    currFile = resolveTreeSelection()
    return if !currFile
    revert(currFile)

  revertFromEditor: ->
    currFile = resolveEditorFile()
    return if !currFile
    revert(currFile)

  updateFromTreeView: ->
    currFile = resolveTreeSelection()
    return if !currFile
    update(currFile)

  updateFromEditor: ->
    currFile = resolveEditorFile()
    return if !currFile
    update(currFile)
