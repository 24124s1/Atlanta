-- variables
	local uis = cloneref(game:GetService("UserInputService"))
	local players = cloneref(game:GetService("Players"))
	local ws = cloneref(game:GetService("Workspace"))
	local http_service = cloneref(game:GetService("HttpService"))
	local gui_service = cloneref(game:GetService("GuiService"))
	local lighting = cloneref(game:GetService("Lighting"))
	local run = cloneref(game:GetService("RunService"))
	local stats = cloneref(game:GetService("Stats"))
	local coregui = cloneref(game:GetService("CoreGui"))
	local debris = cloneref(game:GetService("Debris"))
	local tween_service = cloneref(game:GetService("TweenService"))
	local sound_service = cloneref(game:GetService("SoundService"))
	local starter_gui = cloneref(game:GetService("StarterGui"))
	local rs = cloneref(game:GetService("ReplicatedStorage"))

	local vec2 = Vector2.new
	local vec3 = Vector3.new
	local dim2 = UDim2.new
	local dim = UDim.new 
	local rect = Rect.new
	local cfr = CFrame.new
	local empty_cfr = cfr()
	local point_object_space = empty_cfr.PointToObjectSpace
	local angle = CFrame.Angles
	local dim_offset = UDim2.fromOffset

	local color = Color3.new
	local hsv = Color3.fromHSV
	local rgb = Color3.fromRGB
	local hex = Color3.fromHex
	local rgbseq = ColorSequence.new
	local rgbkey = ColorSequenceKeypoint.new
	local numseq = NumberSequence.new
	local numkey = NumberSequenceKeypoint.new

	local camera = ws.CurrentCamera
	local lp = players.LocalPlayer 
	local mouse = lp:GetMouse() 
	local gui_offset = gui_service:GetGuiInset().Y

	local max = math.max 
	local floor = math.floor 
	local min = math.min 
	local abs = math.abs 
	local noise = math.noise
	local rad = math.rad 
	local random = math.random 
	local pow = math.pow 
	local sin = math.sin 
	local pi = math.pi 
	local tan = math.tan 
	local atan2 = math.atan2 
	local cos = math.cos 
	local round = math.round;
	local clamp = math.clamp; 
	local ceil = math.ceil; 
	local sqrt = math.sqrt;
	local acos = math.acos; 

	local insert = table.insert 
	local find = table.find 
	local remove = table.remove
	local concat = table.concat
-- 

-- library init
	local library = {
		directory = "Atlanta",
		folders = {
			"/fonts",
			"/configs",
			"/images"
		},
		flags = {},
		config_flags = {},
		visible_flags = {}, 
		guis = {}, 
		connections = {},   
		notifications = {},
		playerlist_data = {},

		current_tab, 
		current_element_open, 
		dock_button_holder,  
		old_config; 
		font, 
		keybind_list,
		binds = {}, 
		
		copied_flag; 
		is_rainbow;

		instances = {}; 
		drawings = {};

		display_orders = 0; 
	}

	local flags = library.flags
	local config_flags = library.config_flags

	local themes = {
		preset = {
			["outline"] = hex("#0A0A0A"), -- 
			["inline"] = hex("#2D2D2D"), --
			["accent"] = hex("#6078BE"), --
			["high_contrast"] = hex("#141414"),
			["low_contrast"] = hex("#1E1E1E"),
			["text"] = hex("#B4B4B4"),
			["text_outline"] = rgb(0, 0, 0),
			["glow"] = hex("#6078BE"), 
		},

		utility = {
			["outline"] = {
				["BackgroundColor3"] = {}, 	
				["Color"] = {}, 
			},
			["inline"] = {
				["BackgroundColor3"] = {}, 	
				["ImageColor3"] = {},
			},
			["accent"] = {
				["BackgroundColor3"] = {}, 	
				["TextColor3"] = {}, 
				["ImageColor3"] = {}, 
				["ScrollBarImageColor3"] = {} 
			},
			["contrast"] = {
				["Color"] = {}, 	
			},
			["text"] = {
				["TextColor3"] = {}, 	
			},
			["text_outline"] = {
				["Color"] = {}, 	
			},
			["glow"] = {
				["ImageColor3"] = {}, 	
			}, 
			["high_contrast"] = {
				["BackgroundColor3"] = {},
			},
			["low_contrast"] = {
				["BackgroundColor3"] = {},
			}
		}, 

		find = {
			["Frame"] = "BackgroundColor3", 
			["TextLabel"] = "TextColor3", 
			["UIGradient"] = "Color",
			["UIStroke"] = "Color",
			["ImageLabel"] = "ImageColor3",
			["TextButton"] = "BackgroundColor3", 
			["ScrollingFrame"] = "ScrollBarImageColor3"
		}
	}

	local keys = {
		[Enum.KeyCode.LeftShift] = "LS",
		[Enum.KeyCode.RightShift] = "RS",
		[Enum.KeyCode.LeftControl] = "LC",
		[Enum.KeyCode.RightControl] = "RC",
		[Enum.KeyCode.Insert] = "INS",
		[Enum.KeyCode.Backspace] = "BS",
		[Enum.KeyCode.Return] = "Ent",
		[Enum.KeyCode.LeftAlt] = "LA",
		[Enum.KeyCode.RightAlt] = "RA",
		[Enum.KeyCode.CapsLock] = "CAPS",
		[Enum.KeyCode.One] = "1",
		[Enum.KeyCode.Two] = "2",
		[Enum.KeyCode.Three] = "3",
		[Enum.KeyCode.Four] = "4",
		[Enum.KeyCode.Five] = "5",
		[Enum.KeyCode.Six] = "6",
		[Enum.KeyCode.Seven] = "7",
		[Enum.KeyCode.Eight] = "8",
		[Enum.KeyCode.Nine] = "9",
		[Enum.KeyCode.Zero] = "0",
		[Enum.KeyCode.KeypadOne] = "Num1",
		[Enum.KeyCode.KeypadTwo] = "Num2",
		[Enum.KeyCode.KeypadThree] = "Num3",
		[Enum.KeyCode.KeypadFour] = "Num4",
		[Enum.KeyCode.KeypadFive] = "Num5",
		[Enum.KeyCode.KeypadSix] = "Num6",
		[Enum.KeyCode.KeypadSeven] = "Num7",
		[Enum.KeyCode.KeypadEight] = "Num8",
		[Enum.KeyCode.KeypadNine] = "Num9",
		[Enum.KeyCode.KeypadZero] = "Num0",
		[Enum.KeyCode.Minus] = "-",
		[Enum.KeyCode.Equals] = "=",
		[Enum.KeyCode.Tilde] = "~",
		[Enum.KeyCode.LeftBracket] = "[",
		[Enum.KeyCode.RightBracket] = "]",
		[Enum.KeyCode.RightParenthesis] = ")",
		[Enum.KeyCode.LeftParenthesis] = "(",
		[Enum.KeyCode.Semicolon] = ",",
		[Enum.KeyCode.Quote] = "'",
		[Enum.KeyCode.BackSlash] = "\\",
		[Enum.KeyCode.Comma] = ",",
		[Enum.KeyCode.Period] = ".",
		[Enum.KeyCode.Slash] = "/",
		[Enum.KeyCode.Asterisk] = "*",
		[Enum.KeyCode.Plus] = "+",
		[Enum.KeyCode.Period] = ".",
		[Enum.KeyCode.Backquote] = "`",
		[Enum.UserInputType.MouseButton1] = "MB1",
		[Enum.UserInputType.MouseButton2] = "MB2",
		[Enum.UserInputType.MouseButton3] = "MB3",
		[Enum.KeyCode.Escape] = "ESC",
		[Enum.KeyCode.Space] = "SPC",
	}
		
	library.__index = library

	for _, path in next, library.folders do 
		makefolder(library.directory .. path)
	end 

	writefile("ffff.ttf", game:HttpGet("https://github.com/weasely111/beta/raw/refs/heads/main/fs-tahoma-8px.ttf"))

	local tahoma = {
		name = "SmallestPixel7",
		faces = {
			{
				name = "Regular",
				weight = 400,
				style = "normal",
				assetId = getcustomasset("ffff.ttf")
			}
		}
	}

	writefile("dddd.ttf", http_service:JSONEncode(tahoma))

	library.font = Font.new(getcustomasset("dddd.ttf"), Enum.FontWeight.Regular)

	local config_holder 
-- 

-- library functions 
	-- misc functions
		function library:hoverify(hover, parent) 
			local hover_instance = library:create("Frame", {
				Parent = parent,
				BackgroundTransparency = 1,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				ZIndex = 1;
			}) library:apply_theme(hover_instance, "accent", "BackgroundColor3") 

			hover.MouseEnter:Connect(function()
				library:tween(hover_instance, {
					BackgroundTransparency = 0, 
				}) 
			end)
			
			hover.MouseLeave:Connect(function()
				library:tween(hover_instance, {
					BackgroundTransparency = 1, 
				}) 
			end)

			return hover_instance;
		end 

		function library:hovering(Object)
			if type(Object) == "table" then 
				local Pass = false;

				for _,obj in Object do 
					if library:hovering(obj) then 
						Pass = true
						return Pass
					end 
				end 
			else 
				local y_cond = Object.AbsolutePosition.Y <= mouse.Y and mouse.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
				local x_cond = Object.AbsolutePosition.X <= mouse.X and mouse.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
				
				return (y_cond and x_cond)
			end 
		end  

		function library:make_resizable(frame) 
			local Frame = Instance.new("TextButton")
			Frame.Position = dim2(1, -10, 1, -10)
			Frame.BorderColor3 = rgb(0, 0, 0)
			Frame.Size = dim2(0, 10, 0, 10)
			Frame.BorderSizePixel = 0
			Frame.BackgroundColor3 = rgb(255, 255, 255)
			Frame.Parent = frame
			Frame.BackgroundTransparency = 1 
			Frame.Text = ""

			local resizing = false 
			local start_size 
			local start 
			local og_size = frame.Size  

			Frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					resizing = true
					start = input.Position
					start_size = frame.Size
				end
			end)

			Frame.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					resizing = false
				end
			end)

			library:connection(uis.InputChanged, function(input, game_event) 
				if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
					local viewport_x = camera.ViewportSize.X
					local viewport_y = camera.ViewportSize.Y

					local current_size = dim2(
						start_size.X.Scale,
						math.clamp(
							start_size.X.Offset + (input.Position.X - start.X),
							og_size.X.Offset,
							viewport_x
						),
						start_size.Y.Scale,
						math.clamp(
							start_size.Y.Offset + (input.Position.Y - start.Y),
							og_size.Y.Offset,
							viewport_y
						)
					)
					frame.Size = current_size
				end
			end)
		end

		function library:draggify(frame)
			local dragging = false 
			local start_size = frame.Position
			local start 

			frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					start = input.Position
					start_size = frame.Position

					if library.current_element_open then 
						library.current_element_open.set_visible(false)
						library.current_element_open.open = false 
						library.current_element_open = nil 
					end 

					if frame.Parent:IsA("ScreenGui") and frame.Parent.DisplayOrder ~= 999999 then 
						library.display_orders += 1 -- shit code
						frame.Parent.DisplayOrder = library.display_orders
					end   
				end
			end)

			frame.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			library:connection(uis.InputChanged, function(input, game_event) 
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local viewport_x = camera.ViewportSize.X
					local viewport_y = camera.ViewportSize.Y

					local current_position = dim2(
						0,
						clamp(
							start_size.X.Offset + (input.Position.X - start.X),
							0,
							viewport_x - frame.Size.X.Offset
						),
						0,
						clamp(
							start_size.Y.Offset + (input.Position.Y - start.Y),
							0,
							viewport_y - frame.Size.Y.Offset
						)
					)

					frame.Position = current_position
				end
			end)
		end

		function library:new_drawing(class, properties)
			local ins = Drawing.new(class)

			for _, v in next, properties do 
				ins[_] = v
			end 

			insert(library.drawings, ins)

			return ins 
		end 
		
		function library:new_item(class, properties) 
			local ins = Instance.new(class)

			for _, v in next, properties do 
				ins[_] = v
			end 

			insert(library.instances, ins)

			return ins 
		end 

		function library:convert_enum(enum)
			local enum_parts = {}
		
			for part in string.gmatch(enum, "[%w_]+") do
				insert(enum_parts, part)
			end
		
			local enum_table = Enum
			for i = 2, #enum_parts do
				local enum_item = enum_table[enum_parts[i]]
		
				enum_table = enum_item
			end
		
			return enum_table
		end

		function library:tween(obj, properties) 
			local tween = tween_service:Create(obj, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()
				
			return tween
		end 

		function library:config_list_update() 
			if not config_holder then return end 
		
			local list = {}
		
			for idx, file in next, listfiles(library.directory .. "/configs") do
				local name = string.sub(file:gsub(library.directory .. "/configs\\", ""):gsub(library.directory .. "\\configs\\", ""), 1, -5)
				list[#list + 1] = name
			end
			
			config_holder.refresh_options(list)
		end 

		function library:get_config()
			local Config = {}
		
			for _, v in flags do
				if type(v) == "table" and v.key then
					Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
				elseif type(v) == "table" and v["Transparency"] and v["Color"] then
					Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
				else
					Config[_] = v
				end
			end 
			
			return http_service:JSONEncode(Config)
		end

		function library:load_config(config_json) 
			local config = http_service:JSONDecode(config_json)
		
			for _, v in next, config do 
				local function_set = library.config_flags[_]
				
				if function_set then 
					if type(v) == "table" and v["Transparency"] and v["Color"] then
						function_set(hex(v["Color"]), v["Transparency"])
					elseif type(v) == "table" and v["active"] then 
						function_set(v)
					else 
						function_set(v)
					end
				end 
			end 
		end 
		
		function library:round(number, float) 
			local multiplier = 1 / (float or 1)

			return floor(number * multiplier + 0.5) / multiplier
		end 

		function library:apply_theme(instance, theme, property) 
			insert(themes.utility[theme][property], instance)
		end

		function library:update_theme(theme, color)
			for _, property in next, themes.utility[theme] do 

				for m, object in next, property do 
					if object[_] == themes.preset[theme] or object.ClassName == "UIGradient" then
						object[_] = color 
					end
				end 
			end 

			themes.preset[theme] = color 
		end 

		function library:connection(signal, callback)
			local connection = signal:Connect(callback)
			
			insert(library.connections, connection)

			return connection 
		end

		function library:apply_stroke(parent) 
			local stroke = library:create("UIStroke", {
				Parent = parent,
				Color = themes.preset.text_outline, 
				LineJoinMode = Enum.LineJoinMode.Miter
			}) 
			
			library:apply_theme(stroke, "text_outline", "Color")
		end

		function library:create(instance, options)
			local ins = Instance.new(instance) 
			
			for prop, value in next, options do 
				ins[prop] = value
			end
			
			if instance == "TextLabel" or instance == "TextButton" or instance == "TextBox" then 	
				library:apply_theme(ins, "text", "TextColor3")
				library:apply_stroke(ins)
			elseif instance == "ScreenGui" then 
				insert(library.guis, ins)
			end
			
			return ins 
		end
	-- 

	-- elements 
		local tooltip_sgui = library:create("ScreenGui", {
			Enabled = true,
			Parent = gethui(),
			Name = "",
			DisplayOrder = 500, 
		})

		function library:tool_tip(options) 
			local cfg = {
				name = options.name or "hi", 
				path = options.path or nil, 
			}

			if cfg.path then 
				local watermark_outline = library:create("Frame", {
					Parent = tooltip_sgui,
					Name = "",
					Size = dim2(0, 0, 0, 22),
					Position = dim2(0, 500, 0, 300),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					Visible = false,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = themes.preset.outline
				})
				
				local watermark_inline = library:create("Frame", {
					Parent = watermark_outline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				})
				
				local watermark_background = library:create("Frame", {
					Parent = watermark_inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = watermark_background,
					Name = "",
					Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))}
				}); library:apply_theme(UIGradient, "contrast", "Color")
				
				local text = library:create("TextLabel", {
					Parent = watermark_background,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = " " .. cfg.name .. " ",
					Size = dim2(0, 0, 1, 0),
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 0, -1),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIStroke = library:create("UIStroke", {
					Parent = text,
					Name = "",
					LineJoinMode = Enum.LineJoinMode.Miter
				})

				cfg.path.MouseEnter:Connect(function()
					watermark_outline.Visible = true 
				end)   

				cfg.path.MouseLeave:Connect(function()
					watermark_outline.Visible = false 
				end)

				library:connection(uis.InputChanged, function(input)
					if watermark_outline.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then
						watermark_outline.Position = dim_offset(input.Position.X + 10, input.Position.Y + 10)
					end
				end)
			end 
			
			return cfg
		end 

		function library:panel(options) 
			local cfg = {
				name = options.text or options.name or "Window", 
				size = options.size or dim2(0, 530, 0, 590),
				position = options.position or dim2(0, 500, 0, 500),
				anchor_point = options.anchor_point or vec2(0, 0),

				-- button
				image = options.image or "rbxassetid://79856374238119",
				open = options.open or true,

				-- ignore
				items = {},
			}
			
			local items = cfg.items do 
				-- Panel
					items.sgui = library:create("ScreenGui", {
						Enabled = true,
						Parent = gethui(),
						Name = "" 
					})
					
					items.main_holder = library:create("Frame", {
						Parent = items.sgui,
						Name = "",
						AnchorPoint = vec2(cfg.anchor_point.X, cfg.anchor_point.Y),
						Position = cfg.position,
						Active = true, 
						BorderColor3 = rgb(0, 0, 0),
						Size = cfg.size,
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.outline
					})
					library:draggify(items.main_holder)
					library:make_resizable(items.main_holder)

					local Close = library:create( "TextButton" , {
						Parent = items.main_holder;
						FontFace = library.font;
						Name = "\0";
						AnchorPoint = vec2(1, 0);
						Active = false;
						BorderColor3 = rgb(0, 0, 0);
						Text = "X";
						Size = dim2(0, 0, 0, 0);
						Selectable = false;
						Position = dim2(1, -7, 0, 5);
						BorderSizePixel = 0;
						BackgroundTransparency = 1;
						TextXAlignment = Enum.TextXAlignment.Right;
						AutomaticSize = Enum.AutomaticSize.XY;
						TextColor3 = themes.preset.text;
						TextSize = 12;
						ZIndex = 100;
						BackgroundColor3 = rgb(255, 255, 255)
					});

					library:create( "UIStroke" , {
						Parent = Close
					});         
					
					Close.MouseButton1Click:Connect(function()
						items.sgui.Enabled = false;
					end)

					--library:apply_theme(main_holder, "outline", "BackgroundColor3") 
					
					items.window_inline = library:create("Frame", {
						Parent = items.main_holder,
						Name = "",
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.accent
					})
					
					library:apply_theme(items.window_inline, "accent", "BackgroundColor3") 
					
					items.window_holder = library:create("Frame", {
						Parent = items.window_inline,
						Name = "",
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = themes.preset.outline,
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					})
								
					items.UIGradient = library:create("UIGradient", {
						Parent = items.window_holder,
						Name = "",
						Rotation = 90,
						Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
					})
		
					library:apply_theme(items.UIGradient, "contrast", "Color") 
					
					items.text = library:create("TextLabel", {
						Parent = items.window_holder,
						Name = "",
						FontFace = library.font,
						TextColor3 = themes.preset.accent,
						BorderColor3 = rgb(0, 0, 0),
						Text = cfg.name,
						BackgroundTransparency = 1,
						Position = dim2(0, 2, 0, 4),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextSize = 12,
						BackgroundColor3 = rgb(255, 255, 255)
					}) library:apply_theme(items.text, "accent", "TextColor3")
					
					items.UIStroke = library:create("UIStroke", {
						Parent = items.text,
						Name = "",
						LineJoinMode = Enum.LineJoinMode.Miter
					})
					
					items.UIPadding = library:create("UIPadding", {
						Parent = items.window_holder,
						Name = "",
						PaddingBottom = dim(0, 4),
						PaddingRight = dim(0, 4),
						PaddingLeft = dim(0, 4)
					})
					
					items.outline = library:create("Frame", {
						Parent = items.window_holder,
						Name = "",
						Position = dim2(0, 0, 0, 18),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, 0, 1, -18),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.inline
					})
					
					library:apply_theme(items.outline, "inline", "BackgroundColor3") 
					
					items.inline = library:create("Frame", {
						Parent = items.outline,
						Name = "",
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.outline
					})
					
					library:apply_theme(items.inline, "outline", "BackgroundColor3") 
					
					items.holder = library:create("Frame", {
						Parent = items.inline,
						Name = "",
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					})
					
					items.UIGradient = library:create("UIGradient", {
						Parent = items.holder,
						Name = "",
						Rotation = 90,
						Color = rgbseq{
							rgbkey(0, rgb(41, 41, 55)),
							rgbkey(1, rgb(35, 35, 47))
						}
					})
					
					library:apply_theme(items.UIGradient, "contrast", "Color") 
					
					items.UIPadding = library:create("UIPadding", {
						Parent = items.holder,
						Name = "",
						PaddingTop = dim(0, 5),
						PaddingBottom = dim(0, 5),
						PaddingRight = dim(0, 5),
						PaddingLeft = dim(0, 5)
					})
					
					items.glow = library:create("ImageLabel", {
						Parent = items.main_holder,
						Name = "",
						ImageColor3 = themes.preset.glow,
						ScaleType = Enum.ScaleType.Slice,
						BorderColor3 = rgb(0, 0, 0),
						BackgroundColor3 = rgb(255, 255, 255),
						Visible = true,
						Image = "http://www.roblox.com/asset/?id=18245826428",
						BackgroundTransparency = 1,
						ImageTransparency = 0.8, 
						Position = dim2(0, -20, 0, -20),
						Size = dim2(1, 40, 1, 40),
						ZIndex = 2,
						BorderSizePixel = 0,
						SliceCenter = rect(vec2(21, 21), vec2(79, 79))
					}) library:apply_theme(items.glow, "glow", "ImageColor3") 
				-- 
				
				-- Button
					items.button = library:create("TextButton", {
						Parent = library.dock_holder,
						Name = "",
						TextColor3 = rgb(0, 0, 0),
						BorderColor3 = rgb(0, 0, 0),
						Text = "",
						Size = dim2(0, 25, 0, 25),
						BorderSizePixel = 0,
						TextSize = 14,
						BackgroundColor3 = themes.preset.inline
					})
					
					local button_inline = library:create("Frame", {
						Parent = items.button,
						Name = "",
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.outline
					}) library:apply_theme(button_inline, "outline", "BackgroundColor3") 
					
					local button_inline = library:create("Frame", {
						Parent = button_inline,
						Name = "",
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					}) library:apply_theme(button_inline, "inline", "BackgroundColor3")
					
					local UIGradient = library:create("UIGradient", {
						Parent = button_inline,
						Name = "",
						Rotation = 90,
						Color = rgbseq{
							rgbkey(0, rgb(35, 35, 47)),
							rgbkey(1, rgb(41, 41, 55))
						}
					}) library:apply_theme(UIGradient, "contrast", "Color") 
					
					items.Icon = library:create("ImageLabel", {
						Parent = button_inline,
						Name = "",
						ImageColor3 = themes.preset.accent,
						Image = cfg.image,
						BackgroundTransparency = 1,
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, 0, 1, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					}) library:apply_theme(items.Icon, "accent", "ImageColor3") library:apply_theme(items.Icon, "inline", "ImageColor3") 
					
					local UIPadding = library:create("UIPadding", {
						Parent = button_inline,
						Name = "",
						PaddingTop = dim(0, 4),
						PaddingBottom = dim(0, 4),
						PaddingRight = dim(0, 4),
						PaddingLeft = dim(0, 4)
					})
				-- 

				library:tool_tip({name = cfg.name, path = items.button})
			end 

			items.sgui:GetPropertyChangedSignal("Enabled"):Connect(function()
				items.Icon.ImageColor3 = items.sgui.Enabled and themes.preset.accent or themes.preset.inline
			end)

			items.button.MouseButton1Click:Connect(function()
				items.sgui.Enabled = not items.sgui.Enabled
			end)
			
			return setmetatable(cfg, library)
		end 

		local sgui = library:create("ScreenGui", {
			Enabled = true,
			Parent = gethui(),
			Name = "",
			DisplayOrder = 999999, 
		})

		local notif_holder = library:create("ScreenGui", {
			Parent = gethui(),
			Name = "",
			IgnoreGuiInset = true, 
			DisplayOrder = 999999, 
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		})

		function library:fold_elements(origin, elements)
			for _, x in next, elements do 
				local flag = library.visible_flags[x]

				if flag then    
					flag(flags[origin])
				end     
			end 
		end 

		function library:indicator() 
			local cfg = {
				items = {};
			}

			local items = cfg.items; do 
				items.Window = library:create( "Frame" , {
					Parent = sgui;
					Name = "\0";
					Position = dim2(0, 400, 0, 500);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 322, 0, 147);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Window, "outline", "BackgroundColor3"); library:draggify(items.Window)
				
				items.InfoTitle = library:create( "TextLabel" , {
					FontFace = library.font;
					TextColor3 = themes.preset.text;
					BorderColor3 = rgb(0, 0, 0);
					Text = "Indicators";
					Parent = items.Window;
					Name = "\0";
					Size = dim2(1, 0, 0, 0);
					Position = dim2(0, 7, 0, 5);
					BackgroundTransparency = 1;
					TextXAlignment = Enum.TextXAlignment.Left;
					BorderSizePixel = 0;
					ZIndex = 5;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 12;
				}); 

				items.Accent = library:create( "Frame" , {
					Parent = items.Window;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.accent
				});	library:apply_theme(items.Accent, "accent", "BackgroundColor3")
				
				items.Background = library:create( "Frame" , {
					Parent = items.Accent;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.high_contrast
				});	library:apply_theme(items.Background, "high_contrast", "BackgroundColor3")
				
				items.Inline = library:create( "Frame" , {
					Parent = items.Background;
					Name = "\0";
					Position = dim2(0, 4, 0, 18);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -8, 1, -22);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Inline, "outline", "BackgroundColor3")
				
				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Outline, "inline", "BackgroundColor3")
				
				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")
				
				items.Inline = library:create( "Frame" , {
					Parent = items.LowContrast;
					Name = "\0";
					Position = dim2(0, 4, 0, 4);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -8, 1, -8);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Inline, "inline", "BackgroundColor3")
				
				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Outline, "outline", "BackgroundColor3")
				
				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3"); local image_holder = items.LowContrast;
				
				items.Inline = library:create( "Frame" , {
					Parent = items.LowContrast;
					Name = "\0";
					Position = dim2(0, 4, 0, 4);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -8, 1, -8);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Inline, "inline", "BackgroundColor3")
				
				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Outline, "outline", "BackgroundColor3")
				
				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")

				items.InfoTitle = library:create( "TextLabel" , {
					FontFace = library.font;
					TextColor3 = themes.preset.text;
					BorderColor3 = rgb(0, 0, 0);
					Text = "Info";
					Parent = items.Outline;
					Name = "\0";
					Size = dim2(1, 0, 0, 0);
					Position = dim2(0, 7, 0, 5);
					BackgroundTransparency = 1;
					TextXAlignment = Enum.TextXAlignment.Left;
					BorderSizePixel = 0;
					ZIndex = 5;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 12;
				});

				library:create( "UIStroke" , {
					Parent = items.InfoTitle
				});
				
				items.Accent = library:create( "Frame" , {
					Name = "\0";
					Parent = items.LowContrast;
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, 0, 0, 2);
					BackgroundColor3 = themes.preset.accent;
					BorderSizePixel = 0;
				});	library:apply_theme(items.Accent, "accent", "BackgroundColor3");
				
				items.Shadow = library:create( "Frame" , {
					AnchorPoint = vec2(0, 1);
					Parent = items.Accent;
					Name = "\0";
					Position = dim2(0, 0, 1, 0);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, 0, 0, 1);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.accent;
				}); library:apply_theme(items.Shadow, "accent", "BackgroundColor3");
				
				library:create( "UIGradient" , {
					Rotation = 90;
					Parent = items.Shadow;
					Color = rgbseq{rgbkey(0, rgb(150, 150, 150)), rgbkey(1, rgb(150, 150, 150))}
				});
				
				items.holder = library:create( "Frame" , {
					Parent = items.LowContrast;
					Name = "\0";
					Position = dim2(0, 76, 0, 21);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -80, 0, 0);
					BorderSizePixel = 0;
				});	

				library:create("UIListLayout", {
					Parent = items.holder,
					Padding = dim(0, 4),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				items.Inline = library:create( "Frame" , {
					Parent = image_holder;
					Name = "\0";
					Position = dim2(0, 10, 0, 28);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 68, 0, 67);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Inline, "outline", "BackgroundColor3")
				
				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Outline, "inline", "BackgroundColor3")
				
				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")

				items.Profile = library:create( "ImageLabel" , {
					BorderColor3 = rgb(0, 0, 0);
					Parent = items.LowContrast;
					Image = "rbxasset://textures/ui/GuiImagePlaceholder.png";
					BackgroundTransparency = 1;
					Name = "\0";
					Size = dim2(1, 0, 1, 0);
					BorderSizePixel = 0;
				});	

				local section = setmetatable(items, library)
				items.label = section:label({name = "Player: "})
				items.slider = section:slider({name = "Health", custom = rgb(255, 0, 0), min = 0, max = 100, default = 50, input = true})
				
				library:create( "UIStroke" , {
					Parent = items.InfoTitle
				});            
			end

			function cfg.set_visible(bool)
				items.Window.Visible = bool
			end 

			function cfg.change_health(int)
				items.slider.set(int)
			end

			function cfg.change_profile(player)
				items.label.set(string.format("Player: %s (%s)", player.Name, player.DisplayName))
				items.Profile.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=".. player.UserId .."&width=420&height=420&format=png"
			end 

			return setmetatable(cfg, library)
		end     

		function library:window(properties)
			local window = {opened = true}            
			local opened = {}
			local dock_outline;
			local blur = library:create( "BlurEffect" , {
				Parent = lighting;
				Enabled = true;
				Size = 0
			});    

			library.cache = library:create("ScreenGui", {
				Enabled = false,
				Parent = gethui(),
				Name = "" 
			})

			function window.set_menu_visibility(bool) 
				window.opened = bool 
				
				if bool then 
					for _,gui in opened do 
						gui.Enabled = true 
						opened = {}
					end 
				else
					for _,gui in library.guis do 
						if gui.Enabled then 
							gui.Enabled = false
							table.insert(opened, gui)
						end
					end
				end

				library:tween(blur, {Size = bool and (flags["Blur Size"] or 15) or 0})

				dock_outline.Visible = bool;

				sgui.Enabled = true
				notif_holder.Enabled = true
				tooltip_sgui.Enabled = true
				library.cache.Enabled = false

				for _,tooltip in tooltip_sgui:GetChildren() do 
					tooltip.Visible = false;
				end 

				if library.current_element_open then 
					library.current_element_open.set_visible(false)
					library.current_element_open.open = false 
					library.current_element_open = nil 
				end
			end 

			-- dock init
				dock_outline = library:create("Frame", {
					Parent = sgui,
					Name = "",
					Visible = true,
					BorderColor3 = rgb(0, 0, 0),
					AnchorPoint = vec2(0.5, 0),
					Position = dim2(0.5, 0, 0, 20),
					Size = dim2(0, 157, 0, 39),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}); 

				library:apply_theme(dock_outline, "outline", "BackgroundColor3"); 
				dock_outline.Position = dim2(0, dock_outline.AbsolutePosition.X, 0, dock_outline.AbsolutePosition.Y); 
				dock_outline.AnchorPoint = vec2(0, 0); 
				library:draggify(dock_outline);

				local dock_inline = library:create("Frame", {
					Parent = dock_outline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(dock_inline, "inline", "BackgroundColor3") 
				
				local dock_holder = library:create("Frame", {
					Parent = dock_inline,
					Name = "",
					Size = dim2(1, -2, 1, -2),
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = themes.preset.outline,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				}) library:apply_theme(dock_holder, "outline", "BackgroundColor3") 
				
				local accent = library:create("Frame", {
					Parent = dock_holder,
					Name = "",
					Size = dim2(1, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				}) library:apply_theme(accent, "accent", "BackgroundColor3") 
				
				local UIGradient = library:create("UIGradient", {
					Parent = accent,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				}
				})
				
				local button_holder = library:create("Frame", {
					Parent = dock_holder,
					Name = "",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				}) library.dock_holder = button_holder;
				
				local UIListLayout = library:create("UIListLayout", {
					Parent = button_holder,
					Name = "",
					Padding = dim(0, 5),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				
				local UIPadding = library:create("UIPadding", {
					Parent = button_holder,
					Name = "",
					PaddingTop = dim(0, 6),
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})
						
				local UIGradient = library:create("UIGradient", {
					Parent = dock_holder,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
			-- 

			-- keybind list
				local outline = library:create("Frame", {
					Parent = sgui,
					Name = "",
					Visible = false, 
					Active = true,
					Draggable = true, 
					Position = dim2(0, 50, 0, 200),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 182, 0, 25),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				library:apply_theme(outline, "outline", "BackgroundColor3") 
				library:draggify(outline)
				library:make_resizable(outline)
				library.keybind_list_frame = outline 
				
				local inline = library:create("Frame", {
					Parent = outline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				})
				library:apply_theme(inline, "inline", "BackgroundColor3")

				local background = library:create("Frame", {
					Parent = inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, themes.preset.high_contrast),
						rgbkey(1, themes.preset.low_contrast)
					}
				})
				library:apply_theme(UIGradient, "contrast", "Color") 
				
				local bg = library:create("Frame", {
					Parent = background,
					Name = "a",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				}); library:apply_theme(bg, "accent", "BackgroundColor3")
				
				
				library:create("UIGradient", {
					Parent = bg,
					Name = "",
					Enabled = true, 
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})
				
				local text = library:create("TextLabel", {
					Parent = background,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "Keybinds",
					BackgroundTransparency = 1,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					TextSize = 12,
					BackgroundColor3 = themes.preset.text
				}, "text")
				
				local UIStroke = library:create("UIStroke", {
					Parent = text,
					Name = "",
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				local text_holder = library:create("Frame", {
					Parent = background,
					Name = "",
					Position = dim2(0, -2, 1, 1),
					Size = dim2(1, 4, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = themes.preset.outline
				})
				library:apply_theme(text_holder, "outline", "BackgroundColor3")

				local inline = library:create("Frame", {
					Parent = text_holder,
					Name = "",
					Size = dim2(1, -2, 1, -2),
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					--AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = themes.preset.inline
				})
				library:apply_theme(inline, "inline", "BackgroundColor3")
				
				local background = library:create("Frame", {
					Parent = inline,
					Name = "",
					Size = dim2(1, -2, 1, -2),
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					--AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library.keybind_list = background
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, themes.preset.high_contrast),
						rgbkey(1, themes.preset.low_contrast)
					}
				})
				library:apply_theme(UIGradient, "contrast", "Color") 
				
				library:create("UIListLayout", {
					Parent = background,
					Name = "",
					Padding = dim(0, -1),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				
				library:create("UIPadding", {
					Parent = background,
					Name = "",
					PaddingBottom = dim(0, 4),
					PaddingLeft = dim(0, 5)
				})
			--  

			-- main window
				local main_window = library:panel({
					name = properties and properties.name or "Vagrent.cc | ", 
					size = dim2(0, 604, 0, 628),
					position = dim2(0, (camera.ViewportSize.X / 2) - 302 - 96, 0, (camera.ViewportSize.Y / 2) - 421 - 12),
					image = "rbxassetid://98823308062942",
				})

				local items = main_window.items

				window["tab_holder"] = library:create("Frame", {
					Parent = items.holder,
					Name = " ",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 22),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library:create("UIListLayout", {
					Parent = window["tab_holder"],
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = dim(0, 2),
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				local section_holder = library:create("Frame", {
					Parent = items.holder,
					Name = " ",
					BackgroundTransparency = 1,
					Position = dim2(0, -1, 0, 19),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, -22),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				window["section_holder"] = section_holder

				local outline = library:create("Frame", {
					Parent = section_holder,
					Name = "\0",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				
				library:apply_theme(outline, "outline", "BackgroundColor3") 

				local inline = library:create("Frame", {
					Parent = outline,
					Name = "\0",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				})
				
				library:apply_theme(inline, "inline", "BackgroundColor3") 

				local background = library:create("Frame", {
					Parent = inline,
					Name = "\0",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library.section_holder = background

				library:create("UIPadding", {
					Parent = background,
					PaddingTop = dim(0, 4),
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})

				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				})
				
				library:apply_theme(UIGradient, "contrast", "Color") 
				library:make_resizable(items.main_holder) 
			-- 

			-- theming 
				local style = library:panel({
					name = "Style", 
					anchor_point = vec2(0, 0),
					size = dim2(0, 410, 0, 425),
					position = dim2(0, main_window.items.main_holder.AbsolutePosition.X - 402, 0, main_window.items.main_holder.AbsolutePosition.Y),
					image = "rbxassetid://115194686863276",
				})

				local image_base64 = "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" 
				
	
				local watermark = library:watermark({
					icon = "data:image/png;base64," .. icon_base64,
					default = os.date('Vagrant.cc | - %b %d %Y - %H:%M:%S')
				})  

				task.spawn(function()
						while task.wait(1) do 
							watermark.change_text(os.date('Vagrant.cc - Beta - %b %d %Y - %H:%M:%S'))
					end 
				end)

				local items = style.items

				local column = setmetatable(items, library):column() 
				local section = column:section({name = "Theme"})
				section:label({name = "Accent"})
				:colorpicker({name = "Accent", color = themes.preset.accent, flag = "accent", callback = function(color, alpha)
					library:update_theme("accent", color)
				end, flag = "Accent"})
				section:label({name = "Contrast"})
				:colorpicker({name = "Low", color = themes.preset.low_contrast, flag = "low_contrast", callback = function(color)
					if (flags["high_contrast"] and flags["low_contrast"]) then 
						library:update_theme("contrast", rgbseq{
							rgbkey(0, flags["low_contrast"].Color),
							rgbkey(1, flags["high_contrast"].Color)
						})
					end 

					library:update_theme("low_contrast", flags["low_contrast"].Color)
				end})
				:colorpicker({name = "High", color = themes.preset.high_contrast, flag = "high_contrast", callback = function(color)
					library:update_theme("contrast", rgbseq{
						rgbkey(0, flags["low_contrast"].Color),
						rgbkey(1, flags["high_contrast"].Color)
					})

					library:update_theme("high_contrast", flags["high_contrast"].Color)
				end})
				section:label({name = "Inline"})
				:colorpicker({name = "Inline", color = themes.preset.inline, callback = function(color, alpha)
					library:update_theme("inline", color)
				end, flag = "Inline"})
				section:label({name = "Outline"})
				:colorpicker({name = "Outline", color = themes.preset.outline, callback = function(color, alpha)
					library:update_theme("outline", color)
				end, flag = "Outline"})
				section:label({name = "Text Color"})
				:colorpicker({name = "Main", color = themes.preset.text, callback = function(color, alpha)
					library:update_theme("text", color)
				end, flag = "Main"})
				:colorpicker({name = "Outline", color = themes.preset.text_outline, callback = function(color, alpha)
					library:update_theme("text_outline", color)
				end, flag = "Outline"})
				section:label({name = "Glow"})
				:colorpicker({name = "Glow", color = themes.preset.glow, callback = function(color, alpha)
					library:update_theme("glow", color)
				end, flag = "Glow"})
				section:slider({name = "Blur Size", flag = "Blur Size", min = 0, max = 56, default = 15, interval = 1, callback = function(int)
					if window.opened then 
						blur.Size = int
					end
				end})
				local section = column:section({name = "Other"})
				section:label({name = "UI Bind"})
				:keybind({callback = window.set_menu_visibility, key = Enum.KeyCode.Insert})
				section:toggle({name = "Keybind List", flag = "keybind_list", callback = function(bool)
					library.keybind_list_frame.Visible = bool
				end})
				section:toggle({name = "Watermark", flag = "watermark", callback = function(bool)
					watermark.set_visible(bool)
				end})
				section:button_holder({})
				section:button({name = "Copy JobId", callback = function()
					setclipboard(game.JobId)
				end})
				section:button_holder({})
				section:button({name = "Copy GameID", callback = function()
					setclipboard(game.GameId)
				end})
				section:button_holder({})
				section:button({name = "Copy Join Script", callback = function()
					setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)')
				end})
				section:button_holder({})
				section:button({name = "Rejoin", callback = function()
					game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
				end})
				section:button_holder({})
				section:button({name = "Join New Server", callback = function()
					local apiRequest = game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
					local data = apiRequest.data[random(1, #apiRequest.data)]
						
					if data.playing <= flags["max_players"] then 
						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, data.id)
					end 
				end})
				section:slider({name = "Max Players", flag = "max_players", min = 0, max = 40, default = 15, interval = 1})
			-- credits holder
				local credits_holder = library:panel({
					name = "Credits", 
					size = dim2(0, 329, 0, 125),
					position = dim2(0, main_window.items.main_holder.AbsolutePosition.X + main_window.items.main_holder.AbsoluteSize.X + 2, 0, main_window.items.main_holder.AbsolutePosition.Y + 420),
					image = "rbxassetid://105199726008012",
				}) 
	
				local credits_items = credits_holder.items

				local credits_column = setmetatable(credits_items, library):column()
				local credits_section = credits_column:section({name = "Credits :)"})

				credits_section:label({name = "Devs : Cookie & 090"})
				credits_section:label({name = "Tester : War"})
				credits_section:label({name = "Cookie may of not dont the most but i still love him "})
	
			-- cfg holder
				local holder = library:panel({
					name = "Configurations", 
					size = dim2(0, 329, 0, 415),
					position = dim2(0, main_window.items.main_holder.AbsolutePosition.X + main_window.items.main_holder.AbsoluteSize.X + 2, 0, main_window.items.main_holder.AbsolutePosition.Y),
					image = "rbxassetid://105199726008012",
				}) 

				local items = holder.items

				getgenv().load_config = function(name)
					library:load_config(readfile(library.directory .. "/configs/" .. name .. ".cfg"))
				end 

				local column = setmetatable(items, library):column() 
				local section = column:section({name = "Options"})
					config_holder = section:list({flag = "config_name_list"})
					section:textbox({flag = "config_name_text_box"})
					section:button_holder({})
					section:button({name = "Create", callback = function()
						writefile(library.directory .. "/configs/" .. flags["config_name_text_box"] .. ".cfg", library:get_config())
						library:config_list_update()
					end})
					section:button({name = "Delete", callback = function()
						delfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg")
						library:config_list_update()
					end})
					section:button_holder({})
					section:button({name = "Load", callback = function()
						library:load_config(readfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg"))
						library:notification({text = "Loaded Config: " .. flags["config_name_list"], time = 3})
					end})
					section:button({name = "Save", callback = function()
						writefile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg", library:get_config())
						library:config_list_update()
						library:notification({text = "Saved Config: " .. flags["config_name_list"], time = 3})
					end})
					section:button_holder({})
					section:button({name = "Refresh Configs", callback = function()
						library:config_list_update()
					end})
					section:button_holder({})
					section:button({name = "Unload Config", callback = function()
						library:load_config(library.old_config)
					end})
					section:button({name = "Unload Menu", callback = function()
						library:load_config(library.old_config)

						for _, gui in library.guis do 
							gui:Destroy() 
						end 

						for _, connection in library.connections do 
							connection:Disconnect() 
						end

						blur:Destroy()
					end})
			--  

			return setmetatable(window, library)
		end

		function library:watermark(options) 
			local cfg = {
				default = options.text or options.default or os.date('drain.lol | %b %d %Y | %H:%M')
			}

			local watermark_outline = library:create("Frame", {
				Parent = sgui,
				Name = "",
				BorderColor3 = rgb(0, 0, 0),
				AnchorPoint = vec2(1, 1),
				Position = dim2(1, -20, 0, 20),
				Size = dim2(0, 0, 0, 24),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(watermark_outline, "outline", "BackgroundColor3") 
			watermark_outline.Position = dim_offset(watermark_outline.AbsolutePosition.X, watermark_outline.AbsolutePosition.Y)
			library:draggify(watermark_outline)

			local watermark_inline = library:create("Frame", {
				Parent = watermark_outline,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(watermark_inline, "inline", "BackgroundColor3") 
			
			local watermark_background = library:create("Frame", {
				Parent = watermark_inline,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			local UIGradient = library:create("UIGradient", {
				Parent = watermark_background,
				Name = "",
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
			}) library:apply_theme(UIGradient, "contrast", "Color") 

			library:create("UIListLayout", {
				Parent = watermark_background,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0)
			})

			library:create("UIPadding", {
				Parent = watermark_background,
				PaddingLeft = UDim.new(0, 6)
			})

			local icon = library:create("ImageLabel", {
				Parent = watermark_background,
				Name = "",
				Size = dim2(0, 16, 0, 16),
				BackgroundTransparency = 1,
				Image = options.icon or "",
				LayoutOrder = 1
			})
			
			local text = library:create("TextLabel", {
				Parent = watermark_background,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				Size = dim2(0, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255),
				LayoutOrder = 2
			})
			
			library:create("UIStroke", {
				Parent = text,
				Name = "",
				LineJoinMode = Enum.LineJoinMode.Miter
			})
			
			local accent = library:create("Frame", {
				Parent = watermark_outline,
				Name = "",
				Position = dim2(0, 2, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -4, 0, 2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			}) library:apply_theme(accent, "accent", "BackgroundColor3") 
			
			local UIGradient = library:create("UIGradient", {
				Parent = accent,
				Name = "",
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				}
			})
			
			function cfg.change_text(input)
				text.Text = " ".. input .." "
			end 

			function cfg.set_visible(bool) 
				watermark_outline.Visible = bool
			end 


			cfg.change_text(cfg.default)

			return cfg 

		end

		function library:esp_preview(properties)
			local cfg = {items = {}, rotation = 0; objects = {};}

			lp.Character.Archivable = true
			local character = lp.Character:Clone()
			character.Animate:Destroy()

			local items = cfg.items; do 
				items.viewportframe = library:create( "ViewportFrame" , {
					Parent = self.holder;
					BackgroundTransparency = 1;
					Size = dim2(1, 0, 0, 220);
					BorderColor3 = rgb(0, 0, 0);
					ZIndex = 1;
					Position = dim2(0, 0, 0, 10);
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(255, 255, 255)
				});
				
				items.camera = library:create( "Camera" , {
					FieldOfView = 70.00022888183594;
					CameraType = Enum.CameraType.Track;
					Focus = cfr(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1); -- bro wtf is this serializer doing
					CFrame = cfr(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1);
					Parent = ws;
					Name = "\0"
				}); 

				items.viewportframe.CurrentCamera = items.camera -- sick
				character.Parent = items.viewportframe

				items.camera.CameraSubject = character

				library:connection(run.RenderStepped, function()
					task.wait()
					cfg.rotation += 0.5
					character:SetPrimaryPartCFrame(cfr(Vector3.new(0, 1, -6)) * angle(0, math.rad(cfg.rotation), 0))
				end)
			end 

			local objects = cfg.objects; do 
				objects[ "holder" ] = library:create( "Frame" , {
					Parent = items.viewportframe;
					Name = "\0";
					BackgroundTransparency = 1;
					Position = dim2(0.5, 0, 0.5, 10);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 135, 0, 190);
					BorderSizePixel = 0;
					AnchorPoint = vec2(0.5, 0.5);
					BackgroundColor3 = rgb(255, 255, 255)
				});
				
				objects[ "box_outline" ] = library:create( "UIStroke" , {
					Parent = library.cache;
					LineJoinMode = Enum.LineJoinMode.Miter
				});
				
				objects[ "name" ] = library:create( "TextLabel" , {
					FontFace = library.font;
					Parent = library.cache;
					TextColor3 = flags["Name_Color"].Color;
					BorderColor3 = rgb(0, 0, 0);
					Text = string.format("%s (@%s)", lp.DisplayName, lp.Name);
					Name = "\0";
					TextStrokeTransparency = 0;
					AnchorPoint = vec2(0, 1);
					Size = dim2(1, 0, 0, 0);
					BackgroundTransparency = 1;
					Position = dim2(0, 0, 0, -5);
					BorderSizePixel = 0;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 12;
				});
				
				objects[ "box_handler" ] = library:create( "Frame" , {
					Parent = library.cache;
					Name = "\0";
					BackgroundTransparency = 1;
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(255, 255, 255)
				});
				
				objects[ "box_color" ] = library:create( "UIStroke" , {
					Color = rgb(255, 255, 255);
					LineJoinMode = Enum.LineJoinMode.Miter;
					Name = "\0";
					Parent = objects[ "box_handler" ]
				});
				
				objects[ "outline" ] = library:create( "Frame" , {
					Parent = objects[ "box_handler" ];
					Name = "\0";
					BackgroundTransparency = 1;
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(255, 255, 255)
				});
				
				library:create( "UIStroke" , {
					Parent = objects[ "outline" ];
					LineJoinMode = Enum.LineJoinMode.Miter
				});  
				
				-- Corner Boxes
					objects[ "corners" ] = library:create( "Frame" , {
						Visible = true;
						BorderColor3 = rgb(0, 0, 0);
						Parent = library.cache;
						BackgroundTransparency = 1;
						Position = dim2(0, -1, 0, 2);
						Name = "\0";
						Size = dim2(1, 0, 1, 0);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(255, 255, 255)
					});

					objects[ "1" ] = library:create( "Frame" , {
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(0, 0, 0, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0.4, 0, 0, 3);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});
					
					library:create( "Frame" , {
						Parent = objects[ "1" ];
						Position = dim2(0, 1, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, -2);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});
					
					objects[ "2" ] = library:create( "Frame" , {
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(0, 0, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0, 3, 0.25, 0);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});
					
					library:create( "Frame" , {
						Parent = objects[ "2" ];
						Position = dim2(0, 1, 0, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, 1);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});
					
					objects[ "3" ] = library:create( "Frame" , {
						AnchorPoint = vec2(1, 0);
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(1, 0, 0, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0.4, 0, 0, 3);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});
					
					library:create( "Frame" , {
						Parent = objects[ "3" ];
						Position = dim2(0, 1, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, -2);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});
					
					objects[ "4" ] = library:create( "Frame" , {
						AnchorPoint = vec2(1, 0);
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(1, 0, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0, 3, 0.25, 0);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});
					
					library:create( "Frame" , {
						Parent = objects[ "4" ];
						Position = dim2(0, 1, 0, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, 1);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});
					
					objects[ "5" ] = library:create( "Frame" , {
						AnchorPoint = vec2(0, 1);
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(0, -1, 1, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0.4, 0, 0, 3);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});
					
					library:create( "Frame" , {
						Parent = objects[ "5" ];
						Position = dim2(0, 1, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, -2);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});
					
					objects[ "6" ] = library:create( "Frame" , {
						BorderColor3 = rgb(0, 0, 0);
						Rotation = 180;
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(0, 0, 1, -4);
						AnchorPoint = vec2(0, 1);
						Size = dim2(0, 3, 0.25, 1);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});
					
					library:create( "Frame" , {
						Parent = objects[ "6" ];
						Position = dim2(0, 1, 0, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, 1);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});
					
					objects[ "7" ] = library:create( "Frame" , {
						AnchorPoint = vec2(1, 1);
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(1, -1, 1, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0.4, 0, 0, 3);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});
					
					library:create( "Frame" , {
						Parent = objects[ "7" ];
						Position = dim2(0, 1, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, -2);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});
					
					objects[ "7" ] = library:create( "Frame" , {
						BorderColor3 = rgb(0, 0, 0);
						Rotation = 180;
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(1, 0, 1, -4);
						AnchorPoint = vec2(1, 1);
						Size = dim2(0, 3, 0.25, 1);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});
					
					library:create( "Frame" , {
						Parent = objects[ "7" ];
						Position = dim2(0, 1, 0, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, 1);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});
				-- 
				
				-- Healthbar
					objects[ "healthbar_holder" ] = library:create( "Frame" , {
						AnchorPoint = vec2(1, 0);
						Parent = library.cache;
						Name = "\0";
						Position = dim2(0, -5, 0, 0);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0, 4, 1, 0);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});
					
					objects[ "healthbar" ] = library:create( "Frame" , {
						Parent = objects[ "healthbar_holder" ];
						Name = "\0";
						Position = dim2(0, 1, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, -2);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(255, 255, 255)
					});
				-- 

				-- Distance esp
					objects[ "distance" ] = library:create( "TextLabel" , {
						FontFace = library.font;
						TextColor3 = flags["Distance_Color"].Color;
						BorderColor3 = rgb(0, 0, 0);
						Text = "127st";
						Parent = library.cache;
						TextStrokeTransparency = 0;
						Name = "\0";
						Size = dim2(1, 0, 0, 0);
						BackgroundTransparency = 1;
						Position = dim2(0, 0, 1, 5);
						BorderSizePixel = 0;
						AutomaticSize = Enum.AutomaticSize.Y;
						TextSize = 12;
					});                
				-- 

				-- Weapon esp
					objects[ "weapon" ] = library:create( "TextLabel" , {
						FontFace = library.font;
						TextColor3 = flags["Weapon_Color"].Color;
						BorderColor3 = rgb(0, 0, 0);
						Text = "[ Weapon ]";
						Parent = library.cache;
						TextStrokeTransparency = 0;
						Name = "\0";
						Size = dim2(1, 0, 0, 0);
						BackgroundTransparency = 1;
						Position = dim2(0, 0, 1, 19);
						BorderSizePixel = 0;
						AutomaticSize = Enum.AutomaticSize.Y;
						TextSize = 12;
					});
				--  
			end 

			cfg.change_health = function()
				if flags[ "healthbar_holder" ] and flags[ "healthbar_holder" ].Parent ~= objects[ "holder" ] then 
					return 
				end

				local humanoid = character.Humanoid
				
				local multiplier = humanoid.MaxHealth * math.abs(math.sin(tick() * 2)) / humanoid.MaxHealth
				local color = flags[ "Health_Low" ].Color:Lerp( flags["Health_High"].Color, multiplier)
				
				objects[ "healthbar" ].Size = UDim2.new(1, -2, multiplier, -2)
				objects[ "healthbar" ].Position = UDim2.new(0, 1, 1 - multiplier, 1)
				objects[ "healthbar" ].BackgroundColor3 = color
			end -- wtf why diff func defining

			function cfg.refresh_elements( )                                
				objects.holder.Parent = flags["Enabled"] and items.viewportframe or library.cache

				local temp = {
					["Names"] = objects["name"]; 
					["Name_Color"] = {objects["name"]};
					["Healthbar"] = objects[ "healthbar_holder" ];
					["Distance"] = objects[ "distance" ];
					["Weapon"] = objects[ "weapon" ];
					["Distance_Color"] = {objects[ "distance" ]};
					["Weapon_Color"] = {objects[ "weapon" ]};
				}

				for flag,object in temp do 
					if type(object) == "table" then 
						object[1].TextColor3 = flags[flag].Color
					else 
						object.Parent = flags[flag] and objects[ "holder" ] or library.cache
					end
				end 
				
				local is_corner = flags[ "Box_Type" ] == "Corner"

				if flags["Boxes"] then 
					if is_corner then 
						objects[ "corners" ].Parent = objects["holder"]
						objects[ "box_handler" ].Parent = library.cache
						objects[ "box_outline" ].Parent = library.cache
					else 
						objects[ "box_handler" ].Parent = objects[ "holder" ]
						objects[ "box_outline" ].Parent = objects[ "holder" ]
						objects[ "corners" ].Parent = library.cache
					end 
				else
					objects[ "corners" ].Parent =  library.cache
					objects[ "box_handler" ].Parent = library.cache
					objects[ "box_outline" ].Parent = library.cache
				end 

				objects[ "box_color" ].Color = flags["Box_Color"].Color 

				for _, corner in objects[ "corners" ]:GetChildren() do
					corner.Frame.BackgroundColor3 = flags["Box_Color"].Color
				end
			end

			task.spawn(function()
				while true do 
					task.wait()
					cfg.change_health()
				end 
			end)

			return setmetatable(cfg, library)
		end

		function library:refresh_notifications()  	
			for _, notif in next, library.notifications do 
				tween_service:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Position = dim2(0, 20, 0, 72 + (_ * 28))}):Play()
			end     
		end

		function library:notification(properties)
			local cfg = {
				time = properties.time or 5,
				text = properties.text or properties.name or "Notification",
				flashing = false, 
			}
		
			-- Instances
				local watermark_outline = library:create("Frame", {
					Parent = notif_holder,
					Name = "",
					Size = UDim2.new(0, 0, 0, 24),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 20, 0, 72 + (#library.notifications * 28)),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = themes.preset.outline,
					AnchorPoint = Vector2.new(1, 0)
				})
			
				local watermark_inline = library:create("Frame", {
					Parent = watermark_outline,
					Name = "",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				})

				local watermark_background = library:create("Frame", {
					Parent = watermark_inline,
					Name = "",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
		
				local UIGradient = library:create("UIGradient", {
					Parent = watermark_background,
					Name = "",
					Color = ColorSequence.new{
						rgbkey(0, themes.preset.high_contrast),
						rgbkey(1, themes.preset.low_contrast)
					}
				})
		
				local text = library:create("TextLabel", {
					Parent = watermark_background,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "  " .. cfg.text .. "  ",
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, -1),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
		
				local accent = library:create("Frame", {
					Parent = watermark_outline,
					Name = "",
					Position = UDim2.new(0, 2, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = UDim2.new(0, 1, 1, -4),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				})

				library:apply_theme(accent, "accent", "BackgroundColor3")
		
				local UIGradient = library:create("UIGradient", {
					Parent = accent,
					Name = "",
					Rotation = 90,
					Color = ColorSequence.new{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})
				
				local accent_bottom = library:create("Frame", {
					Parent = watermark_outline,
					Name = "",
					Position = UDim2.new(0, 2, 1, -3),
					BorderColor3 = rgb(0, 0, 0),
					Size = UDim2.new(0, -4, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = accent,
					Name = "",
					Rotation = 90,
					Color = ColorSequence.new{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})

				local index = #library.notifications + 1
				library.notifications[index] =watermark_outline

				library:refresh_notifications()

				tween_service:Create(watermark_outline, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {AnchorPoint = Vector2.new(0, 0)}):Play()
				
				tween_service:Create(accent_bottom, TweenInfo.new(cfg.time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(1, -4, 0, 1)}):Play()
			--
			
			task.spawn(function()
				task.wait(cfg.time)

				library.notifications[index] = nil

				tween_service:Create(watermark_outline, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1}):Play()
				
				for _, v in next, watermark_outline:GetDescendants() do 
					if v:IsA("TextLabel") then 
						tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
					elseif v:IsA("Frame") then 
						tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
					elseif v:IsA("ImageLabel") then
						tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {ImageTransparency = 1}):Play()
					elseif v:IsA("UIStroke") then 
						tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Transparency = 1}):Play()
					end 
				end 

				task.wait(1)

				watermark_outline:Destroy()
			end)    
		end 

		function library:tab(options)	
			local cfg = {
				name = options.name or "tab", 
				enabled = false, 
			}
			
			-- button instances
				local tab_holder = library:create("TextButton", {
					Parent = self.tab_holder,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					Name = "\0",
					BorderSizePixel = 0,
					Size = dim2(0, 0, 1, -2),
					ZIndex = 5,
					TextSize = 12,
					BackgroundColor3 = themes.preset.outline,
					AutoButtonColor = false
				}) library:apply_theme(tab_holder, "outline", "BackgroundColor3") 

				local inline = library:create("Frame", {
					Parent = tab_holder,
					Size = dim2(1, -2, 1, 0),
					Name = "\0",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 

				local background = library:create("Frame", {
					Parent = inline,
					Size = dim2(1, -2, 1, -1),
					Name = "\0",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Rotation = 90,
					Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))}
				}) library:apply_theme(UIGradient, "contrast", "Color") 

				local text = library:create("TextLabel", {
					Parent = background,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = cfg.name,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					ZIndex = 5,
					BackgroundColor3 = rgb(255, 255, 255)
				}, "text")
				library:apply_theme(text, "accent", "TextColor3")
			-- 

			-- section instances 
				local section_holder = library:create("Frame", {
					Parent = library.section_holder,
					BackgroundTransparency = 1,
					Name = "\0",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					Visible = false,
					BackgroundColor3 = rgb(255, 255, 255)
				})
			
				cfg["holder"] = section_holder

				library:create("UIListLayout", {
					Parent = section_holder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			-- 

			function cfg.open_tab()
				if library.current_tab and library.current_tab[1] ~= background then 
					local button = library.current_tab[1]
					button.Size = dim2(1, -2, 1, -1)
					button:FindFirstChildOfClass("UIGradient").Rotation = 90
					button:FindFirstChildOfClass("TextLabel").TextColor3 = themes.preset.text
						
					library.current_tab[2].Visible = false
					
					library.current_tab = nil
				end
				
				library.current_tab = {
					background, section_holder
				}
				
				local button = library.current_tab[1] 
				button.Size = dim2(1, -2, 1, 0) -- ENABLED
				button:FindFirstChildOfClass("UIGradient").Rotation = -90
				button:FindFirstChildOfClass("TextLabel").TextColor3 = themes.preset.accent 

				library.current_tab[2].Visible = true 

				if library.current_element_open and library.current_element_open ~= cfg then 
					library.current_element_open.set_visible(false)
					library.current_element_open.open = false 
					library.current_element_open = nil 
				end
			end
			
			tab_holder.MouseButton1Click:Connect(cfg.open_tab)
			
			return setmetatable(cfg, library) 
		end

		function library:column(path) 
			local cfg = {}
			
			local holder = path or self.holder
			
			local column = library:create("Frame", {
				Parent = holder,
				BackgroundTransparency = 1,
				Name = "\0",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(column, "inline", "BackgroundColor3") 
			
			library:create("UIListLayout", {
				Parent = column,
				Padding = dim(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalFlex = Enum.UIFlexAlignment.Fill
			})
			
			cfg["holder"] = column

			return setmetatable(cfg, library) 
		end

		function library:multi_section(options)
			local cfg = {
				names = options.names or {"First", "Second", "Third"}, 
				sections = {},
			}

			local section = library:create("Frame", {
				Parent = self.holder,
				Name = "",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(section, "inline", "BackgroundColor3")
			
			local inline = library:create("Frame", {
				Parent = section,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(inline, "outline", "BackgroundColor3") 
			
			local __background = library:create("Frame", {
				Parent = inline,
				Name = "",
				ClipsDescendants = true,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				ZIndex = 1,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			local accent = library:create("Frame", {
				Parent = __background,
				Name = "",
				Size = dim2(1, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			}) library:apply_theme(accent, "accent", "BackgroundColor3")
			
			local UIGradient = library:create("UIGradient", {
				Parent = accent,
				Name = "",
				Rotation = 90,
				Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(167, 167, 167))}
			}) 
			
			local UIGradient = library:create("UIGradient", {
				Parent = __background,
				Name = "",
				Rotation = 90,
				Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))}
			}) library:apply_theme(UIGradient, "contrast", "Color") 
			
			local tab_holder = library:create("Frame", {
				Parent = __background,
				Name = "",
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				Position = dim2(0, -1, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 2, 0, 21),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			}) 
			
			library:create("UIListLayout", {
				Parent = tab_holder,
				Name = "",
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				Padding = dim(0, -3),
				SortOrder = Enum.SortOrder.LayoutOrder
			})
			
			for _, tab in next, cfg.names do 
				local multi = {
					open = false, 
				} 

				-- Tab
					local tabb = library:create("TextButton", {
						Parent = tab_holder,
						Name = "",
						AutoButtonColor = false,
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Text = "",
						BorderSizePixel = 0,
						Size = dim2(0, 0, 1, 0),
						ZIndex = 1,
						TextSize = 12,
						BackgroundColor3 = themes.preset.outline
					}) library:apply_theme(tabb, "outline", "BackgroundColor3") 
					
					local background = library:create("Frame", {
						Parent = tabb,
						Name = "",
						Size = dim2(1, 0, 1, -2),
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						ZIndex = 1,
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					})
					
					local UIGradient = library:create("UIGradient", {
						Parent = background,
						Name = "",
						Rotation = 90,
						Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))}
					}) library:apply_theme(UIGradient, "contrast", "Color")
					
					local text = library:create("TextLabel", {
						Parent = background,
						Name = "",
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Text = tab,
						BackgroundTransparency = 1,
						Size = dim2(1, 0, 1, 0),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.X,
						TextSize = 12,
						BackgroundColor3 = rgb(255, 255, 255)
					}) library:apply_theme(text, "accent", "TextColor3")
					
					local UIStroke = library:create("UIStroke", {
						Parent = text,
						Name = "",
						LineJoinMode = Enum.LineJoinMode.Miter
					})
				-- 

				-- Element Handler
					local ScrollingFrame = library:create("ScrollingFrame", {
						Parent = __background,
						Name = "",
						ScrollBarImageColor3 = themes.preset.accent,
						Active = true,
						MidImage = "rbxassetid://103468666327206",
						TopImage = "rbxassetid://103468666327206",
						BottomImage = "rbxassetid://103468666327206",
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						ScrollBarThickness = 2,
						Size = dim2(1, 0, 1, -20),
						Visible = false, 
						BackgroundTransparency = 1,
						Position = dim2(0, 0, 0, 24),
						BackgroundColor3 = rgb(255, 255, 255),
						BorderColor3 = rgb(0, 0, 0),
						BorderSizePixel = 0,
						ScrollBarThickness = 2,
						CanvasSize = dim2(0, 0, 0, 0)
					}) library:apply_theme(ScrollingFrame, "accent", "ScrollBarImageColor3") 
					
					local elements = library:create("Frame", {
						Parent = ScrollingFrame,
						Name = "",
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, 0, 0, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					}) multi.holder = elements
					
					local UIListLayout = library:create("UIListLayout", {
						Parent = elements,
						Name = "",
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = dim(0, 4)
					})
					
					local UIPadding = library:create("UIPadding", {
						Parent = ScrollingFrame,
						Name = "",
						PaddingBottom = dim(0, 60)
					})
				--
				
				function multi:open_tab(bool) 
					ScrollingFrame.Visible = bool 
					UIGradient.Rotation = bool and -90 or 90
					tabb.Size = dim2(0, 0, 1, bool and 1 or 0)
					text.TextColor3 = bool and themes.preset.accent or themes.preset.text
				end

				library:connection(tabb.MouseButton1Click, function()
					for _, multi_s in next, cfg.sections do 
						multi_s:open_tab(false)
					end

					if library.current_element_open then 
						library.current_element_open.set_visible(false)
						library.current_element_open.open = false 
						library.current_element_open = nil 
					end

					multi:open_tab(true) 
				end)

				cfg.sections[#cfg.sections + 1] = setmetatable(multi, library)
			end 

			cfg.sections[1]:open_tab(true)

			return unpack(cfg.sections)
		end 

		function library:section(options)
			local cfg = {
				name = options.name or "Section", 
			}
			
			local section = library:create("Frame", {
				Parent = self.holder,
				Name = "\0",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(section, "inline", "BackgroundColor3") 

			local inline = library:create("Frame", {
				Parent = section,
				Name = "\0",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(inline, "outline", "BackgroundColor3") 

			local background = library:create("Frame", {
				Parent = inline,
				Name = "\0",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local text = library:create("TextLabel", {
				Parent = background,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				Name = "\0",
				BackgroundTransparency = 1,
				Position = dim2(0, 6, 0, 4),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIStroke", {
				Parent = text,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			local accent = library:create("Frame", {
				Parent = background,
				Name = "\0",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 0, 2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			}) library:apply_theme(accent, "accent", "BackgroundColor3") 

			local UIGradient = library:create("UIGradient", {
				Parent = accent,
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				}
			})

			local UIGradient = library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
			}) library:apply_theme(UIGradient, "contrast", "Color") 

			local ScrollingFrame = library:create("ScrollingFrame", {
				Parent = background,
				ScrollBarImageColor3 = themes.preset.accent,
				Active = true,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 2,
				MidImage = "rbxassetid://103468666327206",
				TopImage = "rbxassetid://103468666327206",
				BottomImage = "rbxassetid://103468666327206",
				Size = dim2(1, 0, 1, -20),
				BackgroundTransparency = 1,
				Position = dim2(0, 0, 0, 20),
				BackgroundColor3 = rgb(255, 255, 255),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				CanvasSize = dim2(0, 0, 0, 0)
			}) library:apply_theme(ScrollingFrame, "accent", "ScrollBarImageColor3") 

			ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
				if library.current_element_open then 
					library.current_element_open.set_visible(false)
					library.current_element_open.open = false 
					library.current_element_open = nil
				end
			end) 

			local elements = library:create("Frame", {
				Parent = ScrollingFrame,
				Name = "\0",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			cfg.holder = elements 

			library:create("UIListLayout", {
				Parent = elements,
				Padding = dim(0, 4),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			library:create("UIPadding", {
				Parent = ScrollingFrame,
				PaddingBottom = dim(0, 10)
			})

			return setmetatable(cfg, library)
		end

		function library:slider(options)
			local cfg = {
				name = options.name or nil,
				suffix = options.suffix or "",
				flag = options.flag or tostring(2^789),
				callback = options.callback or function() end, 
				visible = options.visible or true, 
				input_disabled = options.input or false,
				custom_color = options.custom or nil; 

				min = options.min or options.minimum or 0,
				max = options.max or options.maximum or 100,
				intervals = options.interval or options.decimal or 1,
				default = options.default or 10,

				dragging = false,
				value = options.default or 10, 
			} 

			-- instances 
				local slider_REAL = library:create("TextLabel", {
					Parent = self.holder, 
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					Name = "slider",
					ZIndex = 1,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local TEXT_LABEL; 
				if cfg.name then 
					local left_components = library:create("Frame", {
						Parent = slider_REAL,
						Name = "left_components",
						BackgroundTransparency = 1,
						Position = dim2(0, 2, 0, -1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(0, 0, 0, 14),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					})
					
					TEXT_LABEL = library:create("TextLabel", {
						Parent = left_components,
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Text = cfg.name,
						Name = "text",
						BackgroundTransparency = 1,
						Size = dim2(0, 0, 1, -1),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.X,
						TextSize = 12,
						BackgroundColor3 = rgb(255, 255, 255)
					}, "text")

					library:create("UIListLayout", {
						Parent = left_components,
						Padding = dim(0, 5),
						Name = "_",
						FillDirection = Enum.FillDirection.Horizontal
					})
				end 
				
				local bottom_components = library:create("Frame", {
					Parent = slider_REAL,
					Name = "bottom_components",
					Position = dim2(0, 0, 0, cfg.name and 15 or 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local slider = library:create("TextButton", {
					Parent = bottom_components,
					Name = "slider",
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -1, 1, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					Text = "",
					AutoButtonColor = false,
				}) library:apply_theme(slider, "outline", "BackgroundColor3") 

				if not cfg.input_disabled then 
					library:hoverify(slider_REAL, slider)
				end

				local inline = library:create("Frame", {
					Parent = slider,
					Name = "inline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					ZIndex = 1;
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 

				local background = library:create("Frame", {
					Parent = inline,
					Name = "background",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
				}) 
				
				local contrast = library:create("Frame", {
					Parent = background,
					Name = "contrast",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local slidertext = library:create("TextLabel", {
					Parent = contrast,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "12.50/100.00",
					Name = "text",
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 0, -1),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					TextSize = 12,
					ZIndex = 2,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local fill = library:create("Frame", {
					Parent = contrast,
					Name = "fill",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = cfg.custom_color or themes.preset.accent
				}) if not cfg.custom_color then library:apply_theme(fill, "accent", "BackgroundColor3") end; 
				
				local UIGradient = library:create("UIGradient", {
					Parent = fill,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = contrast,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}); library:apply_theme(UIGradient, "contrast", "Color")
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})
				
				library:create("UIListLayout", {
					Parent = bottom_components,
					Padding = dim(0, 10),
					Name = "_",
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			--  

			function cfg.set(value)
				if type(value) == "userdata" then 
					return 
				end

				cfg.value = math.clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

				fill.Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)
				slidertext.Text = tostring(cfg.value) .. cfg.suffix .. "/" .. tostring(cfg.max) .. cfg.suffix
				flags[cfg.flag] = cfg.value

				cfg.callback(flags[cfg.flag])
			end

			function cfg.set_element_visible(bool)
				slider_REAL.Visible = bool 

				if TEXT_LABEL then 
					TEXT_LABEL.Visible = bool 
				end 
			end

			if not cfg.input_disabled then 
				library:connection(uis.InputChanged, function(input)
					if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
						local size_x = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
						local value = ((cfg.max - cfg.min) * size_x) + cfg.min
						cfg.set(value)
					end
				end)

				library:connection(uis.InputEnded, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						cfg.dragging = false 
					end 
				end)

				slider.MouseButton1Down:Connect(function()
					cfg.dragging = true
				end)
			end

			if cfg.tooltip then 
				library:tool_tip({name = cfg.tooltip, path = slider_REAL})
			end

			cfg.set(cfg.default)
			cfg.set_element_visible(cfg.visible)
					
			config_flags[cfg.flag] = cfg.set

			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library) 
		end 

		function library:toggle(options)
			local cfg = {
				enabled = options.enabled or nil,
				name = options.name or "Toggle",
				flag = options.flag or tostring(random(1,9999999)),
				callback = options.callback or function() end,
				default = options.default or false,
				colorpicker = options.color or nil,
				visible = options.visible or true,
				tooltip = options.tooltip or nil,
			}

			-- instances
				local toggle_holder = library:create("TextButton", {
					Parent = self.holder,
					FontFace = library.font,
					TextColor3 = rgb(151, 151, 151),
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					Name = "toggle",
					ZIndex = 1,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local right_components = library:create("Frame", {
					Parent = toggle_holder,
					Name = "right_components",
					Position = dim2(1, -1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 0, 0, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				cfg["right_holder"] = right_components
			
				local list = library:create("UIListLayout", {
					Parent = right_components,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = dim(0, 4),
					Name = "list",
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			
				library:create("UIPadding", {
					Parent = toggle_holder
				})
			
				local left_components = library:create("Frame", {
					Parent = toggle_holder,
					Name = "left_components",
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 0, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local text = library:create("TextLabel", {
					Parent = left_components,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = cfg.name,
					Name = "text",
					BackgroundTransparency = 1,
					Size = dim2(0, 0, 1, -1),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
			
				library:create("UIStroke", {
					Parent = text,
					LineJoinMode = Enum.LineJoinMode.Miter
				})
			
				library:create("UIListLayout", {
					Parent = left_components,
					Padding = dim(0, 5),
					Name = "_",
					FillDirection = Enum.FillDirection.Horizontal
				})
			
				local toggle = library:create("TextButton", {
					Parent = left_components,
					Name = "!toggle",
					Text = "",
					AutoButtonColor = false,
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 14, 0, 14),
					BorderSizePixel = 0,
					ZIndex = 1, 
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(toggle, "outline", "BackgroundColor3") 
				library:apply_theme(toggle, "accent", "BackgroundColor3") 

				local inline = library:create("Frame", {
					Parent = toggle,
					Name = "inline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					ZIndex = 2;
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
			
				local accent = library:create("Frame", {
					Parent = inline,
					BackgroundTransparency = 1;
					ZIndex = 3;
					Name = "background",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				})
				library:apply_theme(accent, "accent", "BackgroundColor3") 

				local UIGradient = library:create("UIGradient", {
					Parent = accent,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})

				local background = library:create("Frame", {
					Parent = inline,
					ZIndex = 2;
					Name = "background",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme(background, "accent", "BackgroundColor3") 

				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Rotation = 90,
					Name = "_",
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
			--  

			library:hoverify(toggle_holder, toggle)

			function cfg.set(bool)
				library:tween(accent, {BackgroundTransparency = bool and 0 or 1})
				flags[cfg.flag] = bool
				
				cfg.callback(bool)
			end

			function cfg.set_element_visible(bool)
				toggle_holder.Visible = bool 
			end 
		
			library:connection(toggle_holder.MouseButton1Click, function()
				cfg.enabled = not cfg.enabled
		
				cfg.set(cfg.enabled)
			end)

			library:connection(toggle.MouseButton1Click, function()
				cfg.enabled = not cfg.enabled
		
				cfg.set(cfg.enabled)
			end)

			if cfg.tooltip then 
				library:tool_tip({name = cfg.tooltip, path = toggle_holder})
			end

			cfg.set(cfg.default)
			
			cfg.set_element_visible(cfg.visible)
			
			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library)
		end
		
		function library:colorpicker(options)
			local parent = self.right_holder
			
			local cfg = {
				name = options.name or "Color", 
				flag = options.flag or tostring(2^789),
				color = options.color or color(1, 1, 1), -- Default to white color if not provided
				alpha = options.alpha or 1,
				callback = options.callback or function() end,
				right_holder = self.right_holder,
			}

			local dragging_sat = false 
			local dragging_hue = false 
			local dragging_alpha = false 

			local h, s, v = cfg.color:ToHSV() 
			local a = cfg.alpha 
			
			-- colorpicker button 
				local colorpicker_button = library:create("TextButton", {
					Parent = parent,
					Name = "outline",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 24, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					Text = "",
					AutoButtonColor = false,
				}) library:apply_theme(colorpicker_button, "outline", "BackgroundColor3") 
			
				local inline = library:create("Frame", {
					Parent = colorpicker_button,
					Name = "inline",
					ZIndex = 2;
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
			
				local handler = library:create("Frame", {
					Parent = inline,
					Name = "handler",
					ZIndex = 2;
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(250, 165, 27)
				})

				library:hoverify(colorpicker_button, colorpicker_button)
			
				local UIGradient = library:create("UIGradient", {
					Parent = handler,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})
			-- 

			-- colorpicker instances
				local colorpicker_holder = library:create("Frame", {
					Parent = sgui,
					Name = "colorpicker",
					Position = dim2(0, colorpicker_button.AbsolutePosition.X + 1, 0, colorpicker_button.AbsolutePosition.Y + 17),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 190, 0, 210),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					Visible = false,
					ZIndex = 1
				}) library:apply_theme(colorpicker_holder, "outline", "BackgroundColor3") 

				library:make_resizable(colorpicker_holder)
				
				local window_inline = library:create("Frame", {
					Parent = colorpicker_holder,
					Name = "window_inline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				}) library:apply_theme(window_inline, "accent", "BackgroundColor3") 
				
				local window_holder = library:create("Frame", {
					Parent = window_inline,
					Name = "window_holder",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = themes.preset.outline,
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local UIGradient = library:create("UIGradient", {
					Parent = window_holder,
					Rotation = 90,
					Name = "_",
					Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local text = library:create("TextLabel", {
					Parent = window_holder,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = cfg.name,
					Name = "text",
					BackgroundTransparency = 1,
					Position = dim2(0, 2, 0, 4),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = text,
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				library:create("UIPadding", {
					Parent = window_holder,
					Name = "_",
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})
				
				local main_holder = library:create("Frame", {
					Parent = window_holder,
					Name = "main_holder",
					Position = dim2(0, 0, 0, 20),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, -40),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(main_holder, "inline", "BackgroundColor3") 
				
				cfg.holder = library:create( "Frame" , {
					Parent = colorpicker_holder;
					Name = "\0";
					Position = dim2(0, 6, 1, -21);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -120, 0, 0);
					BorderSizePixel = 0;
				});
				
				local RainbowToggle = setmetatable(cfg, library):toggle({name = "Rainbow", flag = cfg.flag .. "_RAINBOW_FLAG"})

				cfg.holder = library:create( "Frame" , {
					Parent = colorpicker_holder;
					Name = "\0";
					Position = dim2(1, 2, 1, -23);
					BorderColor3 = rgb(0, 0, 0);
					AnchorPoint = vec2(1, 0);
					Size = dim2(1, -80, 0, 0);
					BorderSizePixel = 0;
				});
				
				local section = setmetatable(cfg, library)
				section:button_holder({})
				section:button({name = "Copy", callback = function()
					library.copied_flag = flags[cfg.flag]
					library.is_rainbow = cfg.flag .. "_RAINBOW_FLAG"
				end})
				section:button({name = "Paste", callback = function()
					RainbowToggle.set(library.is_rainbow)
					cfg.set(library.copied_flag.Color, library.copied_flag.Transparency)
				end})

				local main_holder_inline = library:create("Frame", {
					Parent = main_holder,
					Name = "main_holder_inline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(main_holder_inline, "outline", "BackgroundColor3") 
				
				local main_holder_background = library:create("Frame", {
					Parent = main_holder_inline,
					Name = "main_holder_background",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = main_holder_background,
					Rotation = 90,
					Name = "_",
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				library:create("UIPadding", {
					Parent = main_holder_background,
					PaddingTop = dim(0, 4),
					Name = "_",
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})
				
				local alpha = library:create("TextButton", {
					Parent = main_holder_background,
					AnchorPoint = vec2(0, 0.5),
					Name = "alpha",
					Position = dim2(0, 0, 1, -8),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -20, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline,
					Text = "",
					AutoButtonColor = false,
				}) library:apply_theme(alpha, "inline", "BackgroundColor3") 
				
				local outline = library:create("Frame", {
					Parent = alpha,
					Name = "outline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(outline, "outline", "BackgroundColor3") 
				
				local alpha_drag = library:create("Frame", {
					Parent = outline,
					Name = "alpha_drag",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(0, 221, 255)
				})
				
				local alphaind = library:create("ImageLabel", {
					Parent = alpha_drag,
					ScaleType = Enum.ScaleType.Tile,
					BorderColor3 = rgb(0, 0, 0),
					Image = "rbxassetid://18274452449",
					BackgroundTransparency = 1,
					Name = "alphaind",
					Size = dim2(1, 0, 1, 0),
					TileSize = dim2(0, 6, 0, 6),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = alphaind,
					Transparency = numseq{
						numkey(0, 0),
						numkey(1, 1)
					}
				})
				
				local alpha_picker = library:create("Frame", {
					Parent = alpha_drag,
					Name = "alpha_picker",
					BorderMode = Enum.BorderMode.Inset,
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 4, 1, 0),
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local hue = library:create("TextButton", {
					Parent = main_holder_background,
					AnchorPoint = vec2(1, 0),
					Name = "hue",
					Position = dim2(1, -1, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 14, 1, -20),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline,
					Text = "",
					AutoButtonColor = false
				})
				
				local outline = library:create("Frame", {
					Parent = hue,
					Name = "outline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				
				local Frame = library:create("Frame", {
					Parent = outline,
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = Frame,
					Rotation = 270,
					Color = rgbseq{
						rgbkey(0, rgb(255, 0, 0)),
						rgbkey(0.17000000178813934, rgb(255, 255, 0)),
						rgbkey(0.33000001311302185, rgb(0, 255, 0)),
						rgbkey(0.5, rgb(0, 255, 255)),
						rgbkey(0.6700000166893005, rgb(0, 0, 255)),
						rgbkey(0.8299999833106995, rgb(255, 0, 255)),
						rgbkey(1, rgb(255, 0, 0))
					}
				}) 
				
				local hue_picker = library:create("Frame", {
					Parent = Frame,
					Name = "hue_picker",
					BorderMode = Enum.BorderMode.Inset,
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 4),
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local visualize = library:create("Frame", {
					Parent = main_holder_background,
					AnchorPoint = vec2(1, 1),
					Name = "visualize",
					Position = dim2(1, -1, 1, -1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 14, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(visualize, "inline", "BackgroundColor3") 
				
				local outline = library:create("Frame", {
					Parent = visualize,
					Size = dim2(1, -2, 1, -2),
					Name = "outline",
					Active = true,
					BorderColor3 = rgb(0, 0, 0),
					Position = dim2(0, 1, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(outline, "outline", "BackgroundColor3") 
				
				local visualize = library:create("Frame", {
					Parent = outline,
					Size = dim2(1, -2, 1, -2),
					Name = "visualize",
					Active = true,
					BorderColor3 = rgb(0, 0, 0),
					Position = dim2(0, 1, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(0, 221, 255)
				})
				
				local satval_picker = library:create("Frame", {
					Parent = main_holder_background,
					Name = "satval_picker",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -20, 1, -20),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(satval_picker, "inline", "BackgroundColor3") 
				
				local outline = library:create("Frame", {
					Parent = satval_picker,
					Name = "outline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(outline, "outline", "BackgroundColor3") 
				
				local colorpicker = library:create("Frame", {
					Parent = outline,
					Name = "colorpicker",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(0, 221, 255)
				})
				
				local sat = library:create("TextButton", {
					Parent = colorpicker,
					Name = "sat",
					Size = dim2(1, 0, 1, 0),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255),
					Text = "",
					AutoButtonColor = false,
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = sat,
					Rotation = 270,
					Transparency = numseq{
						numkey(0, 0),
						numkey(1, 1)
					},
					Color = rgbseq{
						rgbkey(0, rgb(0, 0, 0)),
						rgbkey(1, rgb(0, 0, 0))
					}
				})
				
				local val = library:create("TextButton", {
					Parent = colorpicker,
					Name = "val",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255),
					Text = "",
					AutoButtonColor = false,
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = val,
					Transparency = numseq{
						numkey(0, 0),
						numkey(1, 1)
					}
				})
				
				local satval_picker_REAL = library:create("Frame", {
					Parent = colorpicker,
					Name = "satval_picker_REAL",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 2, 0, 2),
					BorderSizePixel = 1,
					BackgroundColor3 = rgb(255, 255, 255),
					ZIndex = 3, 
				})
			-- 
				
			function cfg.set_visible(bool)
				colorpicker_holder.Visible = bool

				if bool then 
					if library.current_element_open and library.current_element_open ~= cfg then 
						library.current_element_open.set_visible(false)
						library.current_element_open.open = false 
					end

					library.current_element_open = cfg
					colorpicker_holder.Position = dim2(0, colorpicker_button.AbsolutePosition.X + 1, 0, colorpicker_button.AbsolutePosition.Y + 17)
				end
			end 

			colorpicker_button.MouseButton1Click:Connect(function()		
				cfg.open = not cfg.open

				cfg.set_visible(cfg.open) 
			end)

			function cfg.set(color, alpha)
				if color then 
					h, s, v = color:ToHSV()
				end 
			
				if alpha then 
					a = alpha
				end 
			
				local hsv_position = Color3.fromHSV(h, s, v)
				local Color = Color3.fromHSV(h, s, v)
				
				local value = 1 - h
				local offset = (value < 1) and 0 or -4
				hue_picker.Position = dim2(0, 0, value, offset)

				local offset = (a < 1) and 0 or -4
				alpha_picker.Position = dim2(a, offset, 0, 0)

				alpha_drag.BackgroundColor3 = Color3.fromHSV(h, s, v)
				
				visualize.BackgroundColor3 = Color
				handler.BackgroundColor3 = Color 

				colorpicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				
				cfg.color = Color
				cfg.alpha = a
				
				local s_offset = (s < 1) and 0 or -3
				local v_offset = (1 - v < 1) and 0 or -3
				satval_picker_REAL.Position = dim2(s, s_offset, 1 - v, v_offset)

				flags[cfg.flag] = {} 
				flags[cfg.flag]["Color"] = Color
				flags[cfg.flag]["Transparency"] = a
			
				cfg.callback(Color, a)
			end

			function cfg.update_color() 
				local mouse = uis:GetMouseLocation() 

				if dragging_sat then	
					s = math.clamp((vec2(mouse.X, mouse.Y - gui_offset) - val.AbsolutePosition).X / val.AbsoluteSize.X, 0, 1)
					v = 1 - math.clamp((vec2(mouse.X, mouse.Y - gui_offset) - sat.AbsolutePosition).Y / sat.AbsoluteSize.Y, 0, 1)
				elseif dragging_hue then 
					h = math.clamp(1 - (vec2(mouse.X, mouse.Y - gui_offset) - hue.AbsolutePosition).Y / hue.AbsoluteSize.Y, 0, 1)
				elseif dragging_alpha then 
					a = math.clamp((vec2(mouse.X, mouse.Y - gui_offset) - alpha.AbsolutePosition).X / alpha.AbsoluteSize.X, 0, 1)
				end

				cfg.set(nil, nil)
			end
			
			alpha.MouseButton1Down:Connect(function()
				dragging_alpha = true 
			end)

			hue.MouseButton1Down:Connect(function()
				dragging_hue = true 
			end)

			sat.MouseButton1Down:Connect(function()
				dragging_sat = true  
			end)

			uis.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging_sat = false
					dragging_hue = false
					dragging_alpha = false 
				end
			end)

			uis.InputChanged:Connect(function(input)
				if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
					cfg.update_color() 
				end
			end)	

			task.spawn(function()
				while true do 
					task.wait()
					if flags[cfg.flag .. "_RAINBOW_FLAG"] then 
						cfg.set(
							hsv(math.abs(math.sin(tick())), 
							s, 
							v
						), a) 
					end     
				end     
			end)

			cfg.set(cfg.color, cfg.alpha)

			library.config_flags[cfg.flag] = cfg.set
		
			return setmetatable(cfg, library) 
		end

		function library:keybind(options)
			local parent = self.right_holder

			local cfg = {
				flag = options.flag or "SET ME A FLAG NOWWW!!!!",
				callback = options.callback or function() end,
				open = false,
				binding = nil, 
				name = options.name or nil, 
				ignore_key = options.ignore or false, 
				parent_toggle = options.parent_toggle or nil,
				key = options.key or nil, 
				mode = options.mode or "toggle",
				active = options.default or false, 

				hold_instances = {},
			}

			flags[cfg.flag] = {} 
			
			local KEYBIND_ELEMENT;
			if cfg.name then 
				KEYBIND_ELEMENT = library:create("TextLabel", {
					Parent = library.keybind_list,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "[ Hold ]  Fly - X",
					Size = dim2(1, -5, 0, 18),
					Visible = false, 
					Position = dim2(0, 5, 0, -1),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = themes.preset.text
				}, "text")
			end 

			local element_outline = library:create("TextButton", {
				Parent = parent,
				Name = "",
				BorderColor3 = rgb(0, 0, 0),
				Text = "", 
				Size = dim2(0, 24, 0, 14),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(element_outline, "outline", "BackgroundColor3")

			library:create("UIPadding", {
				Parent = element_outline,
				PaddingRight = dim(0, 2),
			})

			local instance = library:hoverify(element_outline, element_outline)
			instance.Size = dim2(1, 2, 1, 0)

			local inline = library:create("Frame", {
				Parent = element_outline,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Size = dim2(1, -2, 1, -2),
				ZIndex = 2;
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(inline, "inline", "BackgroundColor3") 

			library:create("UIPadding", {
				Parent = inline,
				PaddingRight = dim(0, 2),
			})
			
			local handler = library:create("Frame", {
				Parent = inline,
				Name = "",
				ZIndex = 2;
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local UIGradient = library:create("UIGradient", {
				Parent = handler,
				Name = "",
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
			}); library:apply_theme(UIGradient, "contrast", "Color") 
			
			local key_text = library:create("TextLabel", {
				Parent = handler,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 2;
				Text = "b",
				Size = dim2(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Position = dim2(0, 0, 0, -2),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIPadding", {
				Parent = key_text,
				PaddingLeft = dim(0, 3),
				PaddingRight = dim(0, 2),
			})
			
			-- mode selector
				local keybind_selector = library:create("Frame", {
					Parent = sgui,
					Name = "",
					Position = dim2(0, element_outline.AbsolutePosition.X + 1, 0, element_outline.AbsolutePosition.Y + 17),
					BorderColor3 = rgb(255, 255, 255),
					BorderSizePixel = 2,
					Visible = false, 
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIListLayout", {
					Parent = keybind_selector,
					Name = "",
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = dim(0, 2)
				})
				
				local hold_button = library:create("TextButton", {
					Parent = keybind_selector,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "hold",
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = hold_button,
					Name = "",
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				library:create("UIPadding", {
					Parent = keybind_selector,
					Name = "",
					PaddingTop = dim(0, 3),
					PaddingBottom = dim(0, 5),
					PaddingRight = dim(0, 5),
					PaddingLeft = dim(0, 5)
				})
				
				local toggle_button = library:create("TextButton", {
					Parent = keybind_selector,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "toggle",
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = toggle_button,
					Name = "",
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				local always_button = library:create("TextButton", {
					Parent = keybind_selector,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "always",
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = always_button,
					Name = "",
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = keybind_selector,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}); library:apply_theme(UIGradient, "contrast", "Color")
				
				local UIStroke = library:create("UIStroke", {
					Parent = keybind_selector,
					Name = "",
					Color = themes.preset.inline,
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				})
			-- 

			-- init 
				function cfg.set_visible(bool)
					keybind_selector.Visible = bool
					keybind_selector.Position = dim2(0, element_outline.AbsolutePosition.X + 1, 0, element_outline.AbsolutePosition.Y + 17)

					if bool then 
						if library.current_element_open and library.current_element_open ~= cfg then 
							library.current_element_open.set_visible(false)
							library.current_element_open.open = false 
						end

						library.current_element_open = cfg 
					end
				end 

				function cfg.set_mode(mode) 
					cfg.mode = mode 

					if mode == "always" then
						cfg.set(true)
					elseif mode == "hold" then
						cfg.set(false)
					end

					flags[cfg.flag]["mode"] = mode
				end 

				function cfg.set(input)
					if type(input) == "boolean" then 
						local __cached = input 

						if cfg.mode == "always" then 
							__cached = true 
						end 

						cfg.active = __cached 
						flags[cfg.flag]["active"] = __cached 
						cfg.callback(__cached)
					elseif tostring(input):find("Enum") then 
						input = input.Name == "Escape" and "none" or input
						
						cfg.key = input or "none"	

						local _text = keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")
						local _text2 = (tostring(_text):gsub("KeyCode.", ""):gsub("UserInputType.", "")) or "none"
						cfg.key_name = _text2

						flags[cfg.flag]["mode"] = cfg.mode 
						flags[cfg.flag]["key"] = cfg.key 

						key_text.Text = string.lower(_text2)

						cfg.callback(cfg.active or false)
					elseif find({"toggle", "hold", "always"}, input) then 
						cfg.set_mode(input)

						if input == "always" then 
							cfg.active = true 
						end 

						if options.parent_toggle then
							options.parent_toggle.set(cfg.active)
						end
			
						cfg.callback(cfg.active or false)
					elseif type(input) == "table" then 
						input.key = type(input.key) == "string" and input.key ~= "none" and library:convert_enum(input.key) or input.key

						input.key = input.key == Enum.KeyCode.Escape and "none" or input.key
						cfg.key = input.key or "none"
						
						cfg.mode = input.mode or "toggle"

						if input.active then
							cfg.active = input.active
						end

						local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
						local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))
						
						key_text.Text = string.lower(__text) or "none"
						cfg.key_name = __text
					end 

					flags[cfg.flag] = {
						mode = cfg.mode,
						key = cfg.key, 
						active = cfg.active
					}
					
					if cfg.name then 
						KEYBIND_ELEMENT.Visible = cfg.active

						library:tween(KEYBIND_ELEMENT, {
							TextTransparency = cfg.active and 0 or 1, 
						}) 

						library:tween(KEYBIND_ELEMENT:FindFirstChildOfClass("UIStroke"), {
							Transparency = cfg.active and 0 or 1, 
						}) 
						
						local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
						local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))

						if cfg.name then 
							KEYBIND_ELEMENT.Text = "[ " .. string.upper(string.sub(cfg.mode, 1, 1)) .. string.sub(cfg.mode, 2) .. " ] " .. cfg.name .. " - " .. __text
						end
					end
				end


				-- ok bro its 30 april2025.. what is this code from october 2024 💀💀
				hold_button.MouseButton1Click:Connect(function()
					cfg.set_mode("hold") 
					cfg.set_visible(false)
					cfg.open = false 
				end) 

				toggle_button.MouseButton1Click:Connect(function()
					cfg.set_mode("toggle") 
					cfg.set_visible(false)
					cfg.open = false 
				end) 

				always_button.MouseButton1Click:Connect(function()
					cfg.set_mode("always") 
					cfg.set_visible(false)
					cfg.open = false 
				end) 
				
				element_outline.MouseButton2Click:Connect(function()
					cfg.open = not cfg.open 

					cfg.set_visible(cfg.open)
				end)

				element_outline.MouseButton1Down:Connect(function()
					task.wait()
					key_text.Text = "none"	

					if cfg.binding then return end 

					cfg.binding = library:connection(uis.InputBegan, function(input, game_event)  
						local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

						cfg.set(selected_key)

						cfg.binding:Disconnect() 
						cfg.binding = nil
					end)
				end)

				library:connection(uis.InputBegan, function(input, game_event) 
					local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

					if not game_event then 
						if selected_key == cfg.key then 
							if cfg.mode == "toggle" then 
								cfg.active = not cfg.active
								cfg.set(cfg.active)
							elseif cfg.mode == "hold" then 
								cfg.set(true)
							end
						end
					end
				end)

				library:connection(uis.InputEnded, function(input, game_event) 
					if game_event then 
						return 
					end 

					local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
		
					if selected_key == cfg.key then
						if cfg.mode == "hold" then 
							cfg.set(false)
						end
					end
				end)
		
				cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})
		
				library.config_flags[cfg.flag] = cfg.set
			-- 
			
			library.config_flags[cfg.flag] = cfg.set

			return setmetatable(cfg, library) 
		end 

		function library:dropdown(options)
			local parent = self.holder 

			local cfg = {
				name = options.name or nil,
				flag = options.flag or tostring(random(1,9999999)),

				items = options.items or {"1", "2", "3"},
				callback = options.callback or function() end,
				multi = options.multi or false, 
				visible = options.visible or true,

				open = false, 
				option_instances = {}, 
				multi_items = {}, 
				scrolling = options.scrolling or false, 
				ignore = options.ignore or nil,
			}

			cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or nil

			-- dropdown elements
				local dropdown_REAL = library:create("TextLabel", {
					Parent = parent,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					Name = "dropdown",
					ZIndex = 2,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local main_text      
				if cfg.name then 
					local left_components = library:create("Frame", {
						Parent = dropdown_REAL,
						Name = "left_components",
						BackgroundTransparency = 1,
						Position = dim2(0, 2, 0, -1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(0, 0, 0, 14),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					})

					main_text = library:create("TextLabel", {
						Parent = left_components,
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Text = cfg.name,
						Name = "text",
						BackgroundTransparency = 1,
						Size = dim2(0, 0, 1, -1),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.X,
						TextSize = 12,
						BackgroundColor3 = rgb(255, 255, 255)
					})
					
					library:create("UIStroke", {
						Parent = main_text,
						LineJoinMode = Enum.LineJoinMode.Miter
					})
					
					library:create("UIListLayout", {
						Parent = left_components,
						Padding = dim(0, 5),
						Name = "_",
						FillDirection = Enum.FillDirection.Horizontal
					})

					local right_components = library:create("Frame", {
						Parent = dropdown_REAL,
						Name = "right_components",
						Position = dim2(1, -1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(0, 0, 0, 12),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					})
					cfg["right_holder"] = right_components
		
					local list = library:create("UIListLayout", {
						Parent = right_components,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = dim(0, 4),
						Name = "list",
						SortOrder = Enum.SortOrder.LayoutOrder
					})
				end 

				local bottom_components = library:create("Frame", {
					Parent = dropdown_REAL,
					Name = "bottom_components",
					Position = dim2(0, 0, 0, cfg.name and 15 or 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 26, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local dropdown = library:create("TextButton", {
					Parent = bottom_components,
					Name = "dropdown",
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -27, 1, 18),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					Text = "",
					AutoButtonColor = false, 
				}) library:apply_theme(dropdown, "outline", "BackgroundColor3") 
				
				library:hoverify(dropdown_REAL, dropdown)

				local inline = library:create("Frame", {
					Parent = dropdown,
					Name = "inline",
					ZIndex = 2;
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
				
				local background = library:create("Frame", {
					Parent = inline,
					Name = "background",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					ZIndex = 2;
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				}) library:apply_theme(background, "accent", "BackgroundColor3") 
				
				local contrast = library:create("Frame", {
					Parent = background,
					Name = "contrast",
					ZIndex = 2;
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local plus = library:create("TextLabel", {
					Parent = contrast,
					TextWrapped = true,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 2;
					Text = "+",
					Name = "plus",
					Size = dim2(1, -4, 1, 0),
					Position = dim2(0, 0, 0, -1),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Right,
					FontFace = library.font,
					TextTruncate = Enum.TextTruncate.AtEnd,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = plus,
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				local text = library:create("TextLabel", {
					Parent = contrast,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					ZIndex = 2;
					BorderColor3 = rgb(0, 0, 0),
					Text = "aa",
					Name = "text",
					Size = dim2(1, -4, 1, 0),
					Position = dim2(0, 4, 0, -1),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = text,
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = contrast,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				library:create("UIListLayout", {
					Parent = bottom_components,
					Padding = dim(0, 10),
					Name = "_",
					SortOrder = Enum.SortOrder.LayoutOrder
				})     
			--

			-- dropdown holder
				local dropdown_holder = library:create("Frame", {
					Parent = sgui,
					BorderColor3 = rgb(0, 0, 0),
					Name = "dropdown_holder",
					BackgroundTransparency = 1,
					Position = dim2(0, dropdown.AbsolutePosition.X + 1, 0, dropdown.AbsolutePosition.Y + 22),
					Size = dim2(0, dropdown.AbsoluteSize.X, 0, cfg.scrolling and 180 or 0),
					BorderSizePixel = 0,
					AutomaticSize = cfg.scrolling and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
					BackgroundColor3 = themes.preset.outline,
					Visible = false
				})
				
				local inline = library:create("Frame", {
					Parent = dropdown_holder,
					Size = dim2(1, -2, 1, 2),
					Name = "inline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
				
				local background; 
				if not cfg.scrolling then 
					background = library:create("Frame", {
						Parent = inline,
						BorderColor3 = rgb(0, 0, 0),
						Name = "background",
						BackgroundTransparency = 1,
						Position = dim2(0, 1, 0, 1),
						Size = dim2(1, -2, 1, 1),
						ZIndex = 2,
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.accent
					})
					library:apply_theme(background, "accent", "BackgroundColor3") 
				else 
					background = library:create("ScrollingFrame", {
						Parent = inline,
						BorderColor3 = rgb(0, 0, 0),
						Name = "background",
						BackgroundTransparency = 1,
						MidImage = "rbxassetid://103468666327206",
						TopImage = "rbxassetid://103468666327206",
						BottomImage = "rbxassetid://103468666327206",
						Position = dim2(0, 1, 0, 1),
						Size = dim2(1, -2, 1, 1),
						ZIndex = 2,
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.accent,
						CanvasSize = dim2(0, 0, 0, 0),
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						ScrollBarThickness = 2,
						ScrollBarImageColor3 = themes.preset.accent
					})
					library:apply_theme(background, "accent", "BackgroundColor3") 
					library:apply_theme(background, "accent", "ScrollBarImageColor3") 
				end 
				
				local contrast = library:create("Frame", {
					Parent = background,
					Name = "contrast",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, -3),
					BorderSizePixel = 0,
					ZIndex = 2, 
					BackgroundColor3 = rgb(255, 255, 255),
					AutomaticSize = cfg.scrolling and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
				}); 

				library:create("UIPadding", {
					Parent = contrast,
					PaddingTop = dim(0, 2),
					PaddingBottom = dim(0, 2),
					PaddingRight = dim(0, 0),
					PaddingLeft = dim(0, 4)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = contrast,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
			
				library:create("UIListLayout", {
					Parent = contrast,
					Padding = dim(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local stroke = library:create("UIStroke", {
					Parent = inline,
					Color = themes.preset.outline,
					LineJoinMode = Enum.LineJoinMode.Miter
				}) library:apply_theme(stroke, "outline", "Color") 
			-- 
				
			function cfg.set_element_visible(bool)
				dropdown_REAL.Visible = bool 

				if main_text then 
					main_text.Visible = bool
				end 
			end 

			function cfg.set_visible(bool) 
				library.current_element_open = cfg.ignore or cfg

				dropdown_holder.Visible = bool

				plus.Text = bool and "-" or "+"
				plus.TextSize = bool and 12 or 8

				if bool then 
					if library.current_element_open and library.current_element_open ~= cfg and not cfg.ignore then 
						library.current_element_open.set_visible(false)
						library.current_element_open.open = false 
					end

					dropdown_holder.Size = dim2(0, dropdown.AbsoluteSize.X, 0, dropdown_holder.Size.Y.Offset)
					dropdown_holder.Position = dim2(0, dropdown.AbsolutePosition.X + 1, 0, dropdown.AbsolutePosition.Y + 22)                    
				end
			end

			function cfg.set(value) 
				local selected = {}

				local is_table = type(value) == "table"

				for _,v in next, cfg.option_instances do 
					if v.Text == value or (is_table and find(value, v.Text)) then 
						insert(selected, v.Text)
						cfg.multi_items = selected
						v.TextColor3 = themes.preset.accent
					else 
						v.TextColor3 = themes.preset.text
					end
				end

				text.Text = is_table and concat(selected, ", ") or selected[1] or "nun"
				flags[cfg.flag] = is_table and selected or selected[1]
				cfg.callback(flags[cfg.flag]) 
			end
			
			function cfg:refresh_options(refreshed_list) 
				for _, v in next, cfg.option_instances do 
					v:Destroy() 
				end

				cfg.option_instances = {} 

				for i,v in next, refreshed_list do 
					local TextButton = library:create("TextButton", {
						Parent = contrast,
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, 0, 0, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						TextWrapped = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 2, 
						Text = v,
						BackgroundColor3 = rgb(255, 255, 255)
					}) library:apply_theme(TextButton, "accent", "TextColor3") 
					
					library:create("UIStroke", {
						Parent = TextButton,
						LineJoinMode = Enum.LineJoinMode.Miter
					})

					insert(cfg.option_instances, TextButton)

					TextButton.MouseButton1Down:Connect(function()
						if cfg.multi then 
							local selected_index = find(cfg.multi_items, TextButton.Text)

							if selected_index then 
								remove(cfg.multi_items, selected_index)
							else
								insert(cfg.multi_items, TextButton.Text)
							end

							cfg.set(cfg.multi_items) 				
						else 
							cfg.set_visible(false)
							cfg.open = false 

							cfg.set(TextButton.Text)
						end
					end)
				end
			end

			dropdown.MouseButton1Click:Connect(function()
				cfg.open = not cfg.open 

				cfg.set_visible(cfg.open)
			end)

			cfg:refresh_options(cfg.items) 

			cfg.set(cfg.default)
			
			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			cfg.set_element_visible(cfg.visible)

			return setmetatable(cfg, library)
		end 

		function library:list(options)
			local cfg = {
				callback = options and options.callback or function() end, 

				scale = options.size or 232, 
				items = options.items or {"1", "2", "3"}, 
				-- order = options.order or 1, 
				placeholdertext = options.placeholder or options.placeholdertext or "search here...",
				visible = options.visible or true,

				option_instances = {}, 
				current_instance = nil, 
				flag = options.flag or "flag", 

			} 

			-- instances 
				local list_holder = library:create("TextLabel", {
					Parent = self.holder,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					ZIndex = 2,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIPadding = library:create("UIPadding", {
					Parent = list_holder,
					Name = "",
					PaddingLeft = dim(0, 1)
				})
				
				local UIStroke = library:create("UIStroke", {
					Parent = list_holder,
					Name = ""
				})
				
				local bottom_components = library:create("Frame", {
					Parent = list_holder,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 26, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIListLayout", {
					Parent = bottom_components,
					Name = "",
					Padding = dim(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				
				local list = library:create("Frame", {
					Parent = bottom_components,
					Name = "",
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -27, 1, cfg.scale),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(main_holder, "outline", "BackgroundColor3") 
				
				local inline = library:create("Frame", {
					Parent = list,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
				
				local background = library:create("Frame", {
					Parent = inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				}) library:apply_theme(background, "accent", "BackgroundColor3") 
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local contrast = library:create("Frame", {
					Parent = background,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = contrast,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local ScrollingFrame = library:create("ScrollingFrame", {
					Parent = contrast,
					Name = "",
					ScrollBarImageColor3 = themes.preset.accent,
					Active = true,
					MidImage = "rbxassetid://103468666327206",
					TopImage = "rbxassetid://103468666327206",
					BottomImage = "rbxassetid://103468666327206",
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 2,
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BackgroundColor3 = rgb(255, 255, 255),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					CanvasSize = dim2(0, 0, 0, 0)
				}) library:apply_theme(ScrollingFrame, "accent", "ScrollBarImageColor3") 
				
				local UIPadding = library:create("UIPadding", {
					Parent = ScrollingFrame,
					Name = "",
					PaddingBottom = dim(0, 4),
					PaddingTop = dim(0, 4)
				})
				
				local UIListLayout = library:create("UIListLayout", {
					Parent = ScrollingFrame,
					Name = "",
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			--  

			function cfg.render_option(text) 
				local TextButton = library:create("TextButton", {
					Parent = ScrollingFrame,
					Name = "",
					Text = tostring(text),
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library:apply_theme(TextButton, "accent", "TextColor3") 

				local UIStroke = library:create("UIStroke", {
					Parent = TextButton,
					Name = ""
				})

				return TextButton 
			end 

			function cfg.set_element_visible(bool)
				list_holder.Visible = bool 
			end

			function cfg.refresh_options(options) 
				if type(options) == "function" then 
					return 
				end 

				for _, v in next, cfg.option_instances do 
					v:Destroy() 
				end 

				for _, option in next, options do 
					local button = cfg.render_option(option) 

					insert(cfg.option_instances, button)

					button.MouseButton1Click:Connect(function()
						if cfg.current_instance and cfg.current_instance ~= button then 
							cfg.current_instance.TextColor3 = themes.preset.text 
						end 

						cfg.current_instance = button 
						button.TextColor3 = themes.preset.accent 

						flags[cfg.flag] = button.text
						
						cfg.callback(button.text)
					end)
				end 
			end     

			function cfg.filter_options(text)
				for _, v in next, cfg.option_instances do 
					if string.find(v.Text, text) then 
						v.Visible = true 
					else 
						v.Visible = false
					end
				end
			end 

			function cfg.set(value)
				for _, buttons in next, cfg.option_instances do 
					if buttons.Text == value then 
						buttons.TextColor3 = themes.preset.accent 
					else 
						buttons.TextColor3 = themes.preset.text 
					end 
				end 

				flags[cfg.flag] = value
				cfg.callback(value)
			end 

			cfg.refresh_options(cfg.items) 
			cfg.set_element_visible(cfg.visible)

			library.visible_flags[cfg.flag] = cfg.set_element_visible
			library.config_flags[cfg.flag] = cfg.set

			return setmetatable(cfg, library)
		end 

		function library:textbox(options)
			local cfg = {
				placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
				default = options.default,
				flag = options.flag or "flag",
				callback = options.callback or function() end,
				visible = options.visible or true,
			}
			
			-- instances 
				local textbox_holder = library:create("TextLabel", {
					Parent = self.holder,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					ZIndex = 2,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIPadding", {
					Parent = textbox_holder,
					Name = "",
					PaddingLeft = dim(0, 1)
				})
				
				library:create("UIStroke", {
					Parent = textbox_holder,
					Name = ""
				})
				
				local button = library:create("Frame", {
					Parent = textbox_holder,
					Name = "",
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -27, 0, 18),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				library:hoverify(textbox_holder, button)
				
				library:apply_theme(button, "outline", "BackgroundColor3") 
				
				local inline = library:create("Frame", {
					Parent = button,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					ZIndex = 2;
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				})
				
				library:apply_theme(inline, "inline", "BackgroundColor3") 
				
				local background = library:create("Frame", {
					Parent = inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 2;
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				})
				
				library:apply_theme(background, "accent", "BackgroundColor3") 
				
				local TextBox = library:create("TextBox", {
					Parent = background,
					Name = "",
					CursorPosition = -1,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "", 
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					TextWrapped = true,
					BackgroundTransparency = 1,
					TextTruncate = Enum.TextTruncate.SplitWord,
					PlaceholderText = "Type here...",
					ClearTextOnFocus = false,
					ZIndex = 3;
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = TextBox,
					Name = ""
				})
				
				local TextButton = library:create("TextButton", {
					Parent = background,
					Name = "",
					FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
					TextColor3 = rgb(0, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					TextSize = 14,
					ZIndex = 2;
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = TextButton,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				})
				
				library:apply_theme(UIGradient, "contrast", "Color") 
				
				library:create("UIListLayout", {
					Parent = textbox_holder,
					Name = "",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
					
				TextBox:GetPropertyChangedSignal("Text"):Connect(function()
					flags[cfg.flag] = TextBox.text
					cfg.callback(TextBox.text)
				end)
			-- 

			function cfg.set_element_visible(bool)
				textbox_holder.Visible = bool 
			end

			function cfg.set(text) 
				flags[cfg.flag] = text
				TextBox.Text = text
				cfg.callback(text)
			end 

			if cfg.default then 
				cfg.set(cfg.default) 
			end 

			cfg.set_element_visible(cfg.visible)

			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library) 
		end 

		function library:button_holder(options) 
			local cfg = {
				flag = options.flag or "hi", 
				visible = options.visible or true,
			}

			local button_holder = library:create("TextLabel", {
				Parent = self.holder,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 2,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255), 
			})

			self.current_holder = button_holder

			-- instances 
				library:create("UIStroke", {
					Parent = button_holder,
					Name = ""
				})
				
				library:create("UIListLayout", {
					Parent = button_holder,
					Name = "",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = dim(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			-- 
			
			function cfg.set_element_visible(bool)
				button_holder.Visible = bool 
			end

			cfg.set_element_visible(cfg.visible)

			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library)
		end 

		function library:button(options)
			local cfg = {
				callback = options.callback or function() end, 
				name = options.text or options.name or "Button",
			}   

			local button = library:create("TextButton", {
				Parent = self.current_holder,
				Name = "",
				Position = dim2(0, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -27, 0, 18),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline,
				Text = ""
			})

			library:hoverify(button, button)
			
			library:apply_theme(button, "outline", "BackgroundColor3") 
			
			local inline = library:create("Frame", {
				Parent = button,
				Name = "",
				ZIndex = 2;
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})
			
			library:apply_theme(inline, "inline", "BackgroundColor3") 
			
			local background = library:create("Frame", {
				Parent = inline,
				Name = "",
				ZIndex = 2;
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})
			
			library:apply_theme(background, "accent", "BackgroundColor3") 
			
			local _UIGradient = library:create("UIGradient", {
				Parent = background,
				Name = "",
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				}
			})
			
			library:apply_theme(_UIGradient, "contrast", "Color") 
			
			local contrast = library:create("Frame", {
				Parent = background,
				Name = "",
				ZIndex = 2;
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			local UIGradient = library:create("UIGradient", {
				Parent = contrast,
				Name = "",
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
			})
			
			library:apply_theme(UIGradient, "contrast", "Color") 
			
			local text = library:create("TextLabel", {
				Parent = contrast,
				Name = "",
				TextWrapped = true,
				ZIndex = 2;
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				Size = dim2(1, -4, 1, 0),
				Position = dim2(0, 4, 0, -1),
				BackgroundTransparency = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				BorderSizePixel = 0,
				FontFace = library.font,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			local UIStroke = library:create("UIStroke", {
				Parent = text,
				Name = "",
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			button.MouseButton1Click:Connect(function()
				cfg.callback() 
			end)

			return setmetatable(cfg, library)
		end 

		function library:label(options)
			local cfg = {name = options.text or options.name or "Label"}

			local dropdown = library:create("TextLabel", {
				Parent = self.holder,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 2,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			local UIStroke = library:create("UIStroke", {
				Parent = dropdown,
				Name = ""
			})
			
			local left_components = library:create("Frame", {
				Parent = dropdown,
				Name = "",
				BackgroundTransparency = 1,
				Position = dim2(0, 2, 0, -1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 0, 0, 14),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			local TextLabel = library:create("TextLabel", {
				Parent = left_components,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local right_components = library:create("Frame", {
				Parent = dropdown,
				Name = "right_components",
				Position = dim2(1, -1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 0, 0, 12),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			}) cfg.right_holder = right_components

			local list = library:create("UIListLayout", {
				Parent = right_components,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = dim(0, 4),
				Name = "list",
				SortOrder = Enum.SortOrder.LayoutOrder
			})
			
			local UIStroke = library:create("UIStroke", {
				Parent = TextLabel,
				Name = ""
			})

			function cfg.set(text) 
				TextLabel.Text = text 
			end 
						
			return setmetatable(cfg, library)   
		end 

		function library:playerlist(options) 
			local cfg = {
				callback = options.callback or function() end, 

				labels = {
					name,
					display, 
					uid, 
				}
			}

			local selected_button; 

			local patterns = {
				["Priority"] = rgb(255, 255, 0),
				["Enemy"] = rgb(255, 0, 0),
				["Neutral"] = themes.preset.text,
				["Friendly"] = rgb(0, 255, 255)
			}

			-- elements 
				local playerlist_holder = library:create("TextLabel", {
					Parent = self.holder,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					ZIndex = 2,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIPadding = library:create("UIPadding", {
					Parent = playerlist_holder,
					Name = "",
					PaddingBottom = dim(0, -2),
					PaddingLeft = dim(0, 1)
				})
				
				local UIStroke = library:create("UIStroke", {
					Parent = playerlist_holder,
					Name = ""
				})
				
				local bottom_components = library:create("Frame", {
					Parent = playerlist_holder,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 26, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIListLayout", {
					Parent = bottom_components,
					Name = "",
					Padding = dim(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				
				local list = library:create("Frame", {
					Parent = bottom_components,
					Name = "",
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -27, 1, 232),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(list, "outline", "BackgroundColor3") 
				
				local inline = library:create("Frame", {
					Parent = list,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
				
				local background = library:create("Frame", {
					Parent = inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				}); library:apply_theme(UIGradient, "contrast", "Color") 
				
				local contrast = library:create("Frame", {
					Parent = background,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = contrast,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
				}); library:apply_theme(UIGradient, "contrast", "Color") 
				
				local ScrollingFrame = library:create("ScrollingFrame", {
					Parent = contrast,
					Name = "",
					ScrollBarImageColor3 = themes.preset.accent,
					Active = true,
					MidImage = "rbxassetid://103468666327206",
					TopImage = "rbxassetid://103468666327206",
					BottomImage = "rbxassetid://103468666327206",
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 2,
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BackgroundColor3 = rgb(255, 255, 255),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					CanvasSize = dim2(0, 0, 0, 0)
				}) library:apply_theme(ScrollingFrame, "accent", "ScrollBarImageColor3") 
				
				local UIPadding = library:create("UIPadding", {
					Parent = ScrollingFrame,
					Name = "",
					PaddingTop = dim(0, 4),
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})
				
				local UIListLayout = library:create("UIListLayout", {
					Parent = ScrollingFrame,
					Name = "",
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			-- 

			function cfg.create_player(player) 
				library.playerlist_data[tostring(player)] = {}
				local path = library.playerlist_data[tostring(player)]
				
				local TextButton = library:create("TextButton", {
					Parent = ScrollingFrame,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local player_name = library:create("TextLabel", {
					Parent = TextButton,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = tostring(player),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					LayoutOrder = -100, 
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme(player_name, "text", "TextColor3") 
				library:apply_theme(player_name, "accent", "TextColor3") 
								
				-- local TextLabel = library:create("TextLabel", {
				--     Parent = TextButton,
				--     Name = "",
				--     FontFace = library.font,
				--     TextColor3 = themes.preset.text,
				--     BorderColor3 = rgb(0, 0, 0),
				--     Text = "None",
				--     BackgroundTransparency = 1,
				--     TextXAlignment = Enum.TextXAlignment.Left,
				--     BorderSizePixel = 0,
				--     AutomaticSize = Enum.AutomaticSize.Y,
				--     TextSize = 12,
				--     BackgroundColor3 = rgb(255, 255, 255)
				-- })
								
				-- local Frame = library:create("Frame", {
				--     Parent = TextLabel,
				--     Name = "",
				--     Position = dim2(0, -10, 0, 0),
				--     BorderColor3 = rgb(0, 0, 0),
				--     Size = dim2(0, 1, 0, 12),
				--     BorderSizePixel = 0,
				--     BackgroundColor3 = themes.preset.outline
				-- }) library:apply_theme(main_holder, "outline", "BackgroundColor3") 
				
				local priority_text = library:create("TextLabel", {
					Parent = TextButton,
					Name = "",
					FontFace = library.font,
					TextColor3 = tostring(player) ~= lp.Name and themes.preset.text or rgb(0, 0, 255),
					BorderColor3 = rgb(0, 0, 0),
					Text = tostring(player) ~= lp.Name and "Neutral" or "LocalPlayer",
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local Frame = library:create("Frame", {
					Parent = priority_text,
					Name = "",
					Position = dim2(0, -10, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 1, 0, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(main_holder, "outline", "BackgroundColor3") 
				
				local UIListLayout = library:create("UIListLayout", {
					Parent = TextButton,
					Name = "",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.Fill
				})
				
				local UIPadding = library:create("UIPadding", {
					Parent = TextButton,
					Name = "",
					PaddingRight = dim(0, 2),
					PaddingLeft = dim(0, 2)
				})

				local line = library:create("Frame", {
					Parent = ScrollingFrame,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(main_holder, "outline", "BackgroundColor3") 

				path.instance = TextButton 
				path.line = line 
				path.priority = "Neutral"
				path.priority_text = priority_text
				-- library.selected_player = players[tostring(player)]
				
				TextButton.MouseButton1Click:Connect(function()
					if player_name == lp.Name then 
						return 
					end 

					if selected_button then 
						selected_button.TextColor3 = themes.preset.text 
						selected_button = nil 
					end     

					selected_button = player_name 
					player_name.TextColor3 = themes.preset.accent 

					library.selected_player = player_name.Text
					library.config_flags["PLAYERLIST_DROPDOWN"](path.priority_text.Text)

					if cfg.labels.name then 
						cfg.labels.name.set("User: " .. player_name.Text)
						cfg.labels.display.set("DisplayName: " .. players[player_name.Text].DisplayName)
						cfg.labels.uid.set("User Id: " .. players[player_name.Text].UserId)
					end
				end)

				return path 
			end 

			function cfg.search(text)
				for _, player in next, players:GetPlayers() do 
					local name = tostring(player)
					local path = library.playerlist_data[name]

					if path then 
						local sanity = string.lower(name):match(string.lower(text)) and true or false
						path.instance.Visible = sanity
						path.line.Visible = sanity
					end 
				end 
			end 

			function cfg.remove_player(player) 
				local path = library.playerlist_data[tostring(player)]
				path.instance:Destroy() 
				path.line:Destroy() 
				path = nil 
			end 

			function library.prioritize(text) 
				if not library.selected_player then 
					return 
				end 

				local path = library.playerlist_data[library.selected_player]
				path.priority_text.Text = text
				path.priority_text.TextColor3 = patterns[text]
				path.priority = text
			end 

			function library.get_priority(player) 
				local path = library.playerlist_data[tostring(player)]

				if path then 
					return path.priority
				end 
			end 

			players.PlayerAdded:Connect(cfg.create_player)
			players.PlayerRemoving:Connect(cfg.remove_player)
			
			for _, player in players:GetPlayers() do 
				local player_object = cfg.create_player(player.Name)
				insert(library.playerlist_data, player_object)
			end 

			self:textbox({name = "Search", callback = function(txt)
				cfg.search(txt)
			end})
			cfg.labels.name = self:label({name = "Name: ??"})
			cfg.labels.display = self:label({name = "Display Name: ??"})
			cfg.labels.uid = self:label({name = "User Id: ??"})

			return setmetatable(cfg, library)
		end 
	-- 
-- 

return library, themes; 
