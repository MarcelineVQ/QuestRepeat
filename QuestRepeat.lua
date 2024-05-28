-- Name: QuestRepeat
-- License: LGPL v2.1

local DEBUG_MODE = false

local success = true
local failure = nil

local function qr_print(msg)
  DEFAULT_CHAT_FRAME:AddMessage(msg)
end

local function debug_print(text)
    if DEBUG_MODE == true then DEFAULT_CHAT_FRAME:AddMessage(text) end
end

-------------------------------------------------
-- Table funcs
-------------------------------------------------

local function isempty(t)
  for _ in pairs(t) do
    return false
  end
  return true
end

local function iskey(table,item)
  for k,v in pairs(table) do
    if item == k then
      return true
    end
  end
  return false
end

local function iselem(table,item)
  for k,v in pairs(table) do
    if item == k then
      return true
    end
  end
  return false
end

local function wipe(table)
  for k,_ in pairs(table) do
    table[k] = nil
  end
end

local function tsize(t)
  local c = 0
  for _ in pairs(t) do
    c = c + 1
  end
  return c
end

-------------------------------------------------
-- Data
-------------------------------------------------


-------------------------------------------------

local QuestRepeat = CreateFrame("Frame")

local reward_chosen = { name = nil, item = 0 }

local orig_QuestRewardCompleteButton_OnClick = QuestRewardCompleteButton_OnClick
function QH_QuestRewardCompleteButton_OnClick()
  debug_print(reward_chosen.name)
  if IsControlKeyDown() and reward_chosen.name then
      QuestFrameRewardPanel.itemChoice = reward_chosen.item
  else
    reward_chosen.item = QuestFrameRewardPanel.itemChoice
    reward_chosen.name = QuestRewardTitleText:GetText()
  end
  orig_QuestRewardCompleteButton_OnClick()
end
QuestRewardCompleteButton_OnClick = QH_QuestRewardCompleteButton_OnClick

local orig_QuestFrameRewardPanel_OnShow = QuestFrameRewardPanel_OnShow
function QH_QuestFrameRewardPanel_OnShow()
  orig_QuestFrameRewardPanel_OnShow()

  local quest = QuestRewardTitleText:GetText()
  debug_print("reward: " .. quest)
  if IsControlKeyDown() and reward_chosen.name then
    getglobal("QuestFrameCompleteQuestButton"):Click()
  end
end
QuestFrameRewardPanel_OnShow = QH_QuestFrameRewardPanel_OnShow

local orig_QuestFrameDetailPanel_OnShow = QuestFrameDetailPanel_OnShow
function QH_QuestFrameDetailPanel_OnShow()
  orig_QuestFrameDetailPanel_OnShow()
  local quest = QuestTitleText:GetText()
  debug_print("detail: " .. quest)
  if IsControlKeyDown() then
    getglobal("QuestFrameAcceptButton"):Click()
    -- table.insert(reward_chosen.steps, DETAIL)
  end
end
QuestFrameDetailPanel_OnShow = QH_QuestFrameDetailPanel_OnShow

local orig_QuestFrameGreetingPanel_OnShow = QuestFrameGreetingPanel_OnShow
function QH_QuestFrameGreetingPanel_OnShow()
  orig_QuestFrameGreetingPanel_OnShow()
  local quest = QuestTitleText:GetText()
  -- if IsControlKeyDown() then
  --   getglobal("QuestFrameCompleteButton"):Click()
  --   table.insert(reward_chosen.steps, GREETING)
  -- end
  debug_print("greeting: " .. quest)
end
QuestFrameGreetingPanel_OnShow = QH_QuestFrameGreetingPanel_OnShow

local orig_QuestFrameProgressPanel_OnShow = QuestFrameProgressPanel_OnShow
function QH_QuestFrameProgressPanel_OnShow()
  orig_QuestFrameProgressPanel_OnShow()
  local quest = QuestProgressTitleText:GetText()
  debug_print("progress: " .. quest)
  if IsControlKeyDown() then
    getglobal("QuestFrameCompleteButton"):Click()
    -- table.insert(reward_chosen.steps, PROGRESS)
  end
 end
QuestFrameProgressPanel_OnShow = QH_QuestFrameProgressPanel_OnShow

-- local orig_QuestFrame_OnHide = QuestFrame_OnHide
-- function QH_QuestFrame_OnHide()
--   -- debug_print("foo")
--   -- for i,step in ipairs(reward_chosen.steps) do
--   --   debug_print(reward_chosen.steps[i])
--   -- end
--   -- debug_print(reward_chosen.item_index)
--   orig_QuestFrame_OnHide()
--  end
--  QuestFrame_OnHide = QH_QuestFrame_OnHide

local report_dummies = true
local function OnEvent()
  if event == "GOSSIP_SHOW" and IsControlKeyDown() and reward_chosen.name then
      local titleButton;
      for i=1, NUMGOSSIPBUTTONS do
        titleButton = getglobal("GossipTitleButton" .. i)
        if titleButton:IsVisible() and titleButton:GetText() == reward_chosen.name then
          local qname = titleButton:GetText()
          local btype = titleButton.type
          debug_print(qname .. btype)
          titleButton:Click()
          break
        end
      end
  elseif event == "GOSSIP_SHOW" and not IsControlKeyDown() then
    reward_chosen.name = nil
  elseif event == "ADDON_LOADED" and arg1 == "QuestRepeat" then
    -- load settings
  end
end

QuestRepeat:RegisterEvent("GOSSIP_SHOW")
-- QuestRepeat:RegisterEvent("GOSSIP_CLOSED")
-- QuestRepeat:RegisterEvent("QUEST_PROGRESS")
-- QuestRepeat:RegisterEvent("QUEST_PROGRESS")
-- QuestRepeat:RegisterEvent("QUEST_FINISHED")
-- QuestRepeat:RegisterEvent("QUEST_COMPLETE")
-- QuestRepeat:RegisterEvent("CHAT_MSG_SYSTEM")
-- QuestRepeat:RegisterEvent("PLAYER_ENTERING_WORLD")
QuestRepeat:RegisterEvent("ADDON_LOADED")
QuestRepeat:SetScript("OnEvent", OnEvent)
