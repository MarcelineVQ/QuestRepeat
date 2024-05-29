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

local reward_chosen = { quest = nil, item = 0 }

local function PostHookFunction(original,hook)
  return function(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
    original(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
    hook(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
  end
end

local function PreHookFunction(original,hook)
  return function(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
    hook(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
    original(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
  end
end

--[[ Reward Choice --]]

local function QH_QuestRewardCompleteButton_OnClick()
  debug_print(reward_chosen.quest)
  if IsControlKeyDown() and reward_chosen.quest then
      QuestFrameRewardPanel.itemChoice = reward_chosen.item
  else
    reward_chosen.item = QuestFrameRewardPanel.itemChoice
    reward_chosen.quest = QuestRewardTitleText:GetText()
  end
end
QuestRewardCompleteButton_OnClick = PreHookFunction(QuestRewardCompleteButton_OnClick,QH_QuestRewardCompleteButton_OnClick)

--[[ Passthrogh Panels --]]

local function QH_QuestFrameRewardPanel_OnShow()
  local quest = QuestRewardTitleText:GetText()
  debug_print("reward: " .. quest)
  if IsControlKeyDown() and reward_chosen.quest then
    QuestFrameCompleteQuestButton:Click()
  end
end
QuestFrameRewardPanel_OnShow = PostHookFunction(QuestFrameRewardPanel_OnShow,QH_QuestFrameRewardPanel_OnShow)


local function QH_QuestFrameDetailPanel_OnShow()
  local quest = QuestTitleText:GetText()
  debug_print("detail: " .. quest)
  if IsControlKeyDown() then
    QuestFrameAcceptButton:Click()
  end
end
QuestFrameDetailPanel_OnShow = PostHookFunction(QuestFrameDetailPanel_OnShow,QH_QuestFrameDetailPanel_OnShow)

local function QH_QuestFrameProgressPanel_OnShow()
  local quest = QuestProgressTitleText:GetText()
  debug_print("progress: " .. quest)
  if IsControlKeyDown() then
    QuestFrameCompleteButton:Click()
  end
 end
QuestFrameProgressPanel_OnShow = PostHookFunction(QuestFrameProgressPanel_OnShow,QH_QuestFrameProgressPanel_OnShow)

--[[ Quest Choice Panels --]]

local function QH_QuestFrameGreetingPanel_OnShow()
  local npc = QuestFrameNpcNameText:GetText()
  debug_print("greeting: " .. npc)

  if IsControlKeyDown() and reward_chosen.quest then
    local titleButton;
    for i=1, MAX_NUM_QUESTS do
      titleButton = getglobal("QuestTitleButton" .. i)
      if titleButton:IsVisible() and titleButton:GetText() == reward_chosen.quest then
        local qname = titleButton:GetText()
        debug_print(qname)
        titleButton:Click()
        break
      end
    end
  else
    reward_chosen.quest = nil
  end
end
QuestFrameGreetingPanel_OnShow = PostHookFunction(QuestFrameGreetingPanel_OnShow,QH_QuestFrameGreetingPanel_OnShow)

local function QH_GossipFrame_OnShow()
  local npc = GossipFrameNpcNameText:GetText()
  debug_print("gossip: " .. npc)

  if IsControlKeyDown() and reward_chosen.quest then
    local titleButton;
    for i=1, NUMGOSSIPBUTTONS do
      titleButton = getglobal("GossipTitleButton" .. i)
      if titleButton:IsVisible() and titleButton:GetText() == reward_chosen.quest then
        local qname = titleButton:GetText()
        local btype = titleButton.type
        debug_print(qname .. btype)
        titleButton:Click()
        break
      end
    end
  else
    reward_chosen.quest = nil
  end
end

local function OnEvent()
  if event == "GOSSIP_SHOW" then
    QH_GossipFrame_OnShow()
  end
end

QuestRepeat:RegisterEvent("GOSSIP_SHOW")
QuestRepeat:SetScript("OnEvent", OnEvent)
