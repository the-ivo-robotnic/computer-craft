local pixelui = require("pixelui")
local app = pixelui.create()
local root = app:getRoot()

-- Create UI elements
local progressBar = app:createProgressBar({
  x = 2,
  y = 5,
  width = root.width - 3,
  height = 3,
  label = "Processing...",
  showPercent = true
})
root:addChild(progressBar)

local statusLabel = app:createLabel({
  x = 2,
  y = 9,
  width = root.width - 3,
  height = 1,
  text = "Idle"
})
root:addChild(statusLabel)

local startBtn = app:createButton({
  x = 2,
  y = 11,
  width = 15,
  height = 3,
  label = "Start Task",
  bg = colors.green,
  fg = colors.white
})
root:addChild(startBtn)

local cancelBtn = app:createButton({
  x = 18,
  y = 11,
  width = 15,
  height = 3,
  label = "Cancel",
  bg = colors.red,
  fg = colors.white,
  disabled = true
})
root:addChild(cancelBtn)

local currentHandle = nil

startBtn.onClick = function()
  startBtn.disabled = true
  cancelBtn.disabled = false
  progressBar:setValue(0)
  
  currentHandle = app:spawnThread(function(ctx)
    for i = 1, 100 do
      ctx:setProgress(i / 100)
      ctx:setStatus("Processing item " .. i)
      ctx:sleep(0.1)
      ctx:checkCancelled()
    end
    return "Complete!"
  end, {
    name = "Processing Task",
    onMetadata = function(h, key, value)
      if key == "progress" then
        progressBar:setValue(value)
      elseif key == "status" then
        statusLabel:setText(value)
      end
    end,
    onStatus = function(h, status)
      if status == "completed" then
        statusLabel:setText("Task completed!")
        startBtn.disabled = false
        cancelBtn.disabled = true
      elseif status == "cancelled" then
        statusLabel:setText("Task cancelled")
        startBtn.disabled = false
        cancelBtn.disabled = true
      elseif status == "error" then
        statusLabel:setText("Error: " .. tostring(h:getError()))
        startBtn.disabled = false
        cancelBtn.disabled = true
      end
    end
  })
end

cancelBtn.onClick = function()
  if currentHandle then
    currentHandle:cancel()
  end
end

app:run()