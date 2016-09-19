---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )
local widget = require ("widget")

-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

--from here
local navBarHeight = 60
local tabBarHeight = 50

		-- create a background to fill screen
		local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
		bg:setFillColor( 50/255,50/255,250,255 )   
		bg.anchorX = 0
		bg.anchorY = 0

--tableview
local myTableView = widget.newTableView {
   top = navBarHeight, 
   width = display.contentWidth, 
   height = display.contentHeight - navBarHeight - tabBarHeight,
   onRowRender = onRowRender,
   onRowTouch = onRowTouch,
   listener = scrollListener
}


--load it with data
local myData = {}
myData[1] = { name="Fred",    phone="555-555-1234" }
myData[2] = { name="Barney",  phone="555-555-1235" }
myData[3] = { name="Wilma",   phone="555-555-1236" }
myData[4] = { name="Betty",   phone="555-555-1237" }
myData[5] = { name="Pebbles", phone="555-555-1238" }
myData[6] = { name="BamBam",  phone="555-555-1239" }
myData[7] = { name="Dino",    phone="555-555-1240" }

--passable parameters
for i = 1, #myData do
   myTableView:insertRow{
      rowHeight = 60,
      isCategory = false,
      rowColor = { 1, 1, 1 },
      lineColor = { 0.90, 0.90, 0.90 },
      params = {
         name = myData[i].name,
         phone = myData[i].phone
      }
   }
end


local springStart = 0
local needToReload = false

local function scrollListener( event )
   if ( event.phase == "began" ) then
      springStart = event.target.parent.parent:getContentPosition()
      needToReload = false
   elseif ( event.phase == "moved" ) then
      if ( event.target.parent.parent:getContentPosition() > springStart + 60 ) then
         needToReload = true
      end
   elseif ( event.limitReached == true and event.phase == nil and event.direction == "down" and needToReload == true ) then
      --print( "Reloading Table!" )
      needToReload = false
      reloadTable()
   end
   return true
end



local function onRowRender( event )

   --Set up the localized variables to be passed via the event table

   local row = event.row
   local id = row.index
   local params = event.row.params

   row.bg = display.newRect( 0, 0, display.contentWidth, 60 )
   row.bg.anchorX = 0
   row.bg.anchorY = 0
   row.bg:setFillColor( 1, 1, 1 )
   row:insert( row.bg )

   if ( event.row.params ) then    
      row.nameText = display.newText( params.name, 12, 0, native.systemFontBold, 18 )
      row.nameText.anchorX = 0
      row.nameText.anchorY = 0.5
      row.nameText:setFillColor( 1 )
      row.nameText.y = 20
      row.nameText.x = 42

      row.phoneText = display.newText( params.phone, 12, 0, native.systemFont, 18 )
      row.phoneText.anchorX = 0
      row.phoneText.anchorY = 0.5
      row.phoneText:setFillColor( 0.5 )
      row.phoneText.y = 40
      row.phoneText.x = 42

      row.rightArrow = display.newImageRect( "rightarrow.png", 15 , 40, 40 )
      row.rightArrow.x = display.contentWidth - 20
      row.rightArrow.y = row.height / 2

      row:insert( row.nameText )
      row:insert( row.phoneText )
      row:insert( row.rightArrow )
   end
   return true
end



local reloadBar = display.newRect( display.contentCenterX, display.topStatusBarContentHeight*0.5, display.contentWidth, display.topStatusBarContentHeight )
reloadBar.isVisible = false
reloadBar.isHitTestable = true
--reloadBar:addEventListener( "tap", reloadTable )




local nextSceneButton

function scene:create( event )
    local sceneGroup = self.view

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
        local title = self:getObjectByName( "Title" )
        title.x = display.contentWidth / 2
        title.y = display.contentHeight / 2
        title.size = display.contentWidth / 10
        local goToScene2Btn = self:getObjectByName( "GoToScene2Btn" )
        goToScene2Btn.x = display.contentWidth - 95
        goToScene2Btn.y = display.contentHeight - 35
        local goToScene2Text = self:getObjectByName( "GoToScene2Text" )
        goToScene2Text.x = display.contentWidth - 92
        goToScene2Text.y = display.contentHeight - 35
    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc
        
        -- we obtain the object by id from the scene's object hierarchy
        nextSceneButton = self:getObjectByName( "GoToScene2Btn" )
        if nextSceneButton then
        	-- touch listener for the button
        	function nextSceneButton:touch ( event )
        		local phase = event.phase
        		if "ended" == phase then
        			composer.gotoScene( "scene2", { effect = "fade", time = 300 } )
        		end
        	end
        	-- add the touch event listener to the button
        	nextSceneButton:addEventListener( "touch", nextSceneButton )
        end
        
    end 
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)
    elseif phase == "did" then
        -- Called when the scene is now off screen
		if nextSceneButton then
			nextSceneButton:removeEventListener( "touch", nextSceneButton )
		end
    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
