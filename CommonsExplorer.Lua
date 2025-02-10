local function extract_commons_item(file_name)
    -- 文字列からコモンズ素材(nc123456の部分)を抜き出して返す
    -- 抜き出せなかった場合はnil
    local m = string.match(file_name, "nc[%w_]+")
    if m == nil then
        return nil
    end

    local comons = string.sub(m, 1, -2)
    return comons
end

local function remove_duplicates(array)
    -- 重複削除
    local seen = {}
    local unique = {}
    
    for _, value in ipairs(array) do
        if not seen[value] then
            table.insert(unique, value)
            seen[value] = true 
        end
    end

    return unique
end

local function output_commons_items(commons_items)
    -- ニコニコの仕様どおりにコモンズ素材一覧を出力する
    print(table.concat(commons_items, " "))
end

local function explorer_from_folder(folder,commons_items)
    -- フォルダからコモンズ素材を抽出するやつ
    for k,v in pairs(folder:GetClipList()) do
        -- flagsってなんだよ
        if (k ~= "__flags") then
            local commons_item = extract_commons_item(v:GetClipProperty("File Name"))
            if commons_item ~= nil then
                table.insert(commons_items, commons_item)
            end
        end
    end

    for k,v in pairs(folder:GetSubFolderList()) do
        -- だからflagsってなんなんだよ
        if (k ~= "__flags") then
            explorer_from_folder(v,commons_items)
        end
    end
end

print("ComomnsExplore_Start-------------")

resolve = Resolve()
projectManager = resolve:GetProjectManager()
project = projectManager:GetCurrentProject()
mediaPool = project:GetMediaPool()
folder = mediaPool:GetRootFolder()

commons_items = {}

explorer_from_folder(folder,commons_items)

commons_items = remove_duplicates(commons_items)
output_commons_items(commons_items)