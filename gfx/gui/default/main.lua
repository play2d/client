Window = {
	Background = {220, 220, 220, 255},
	Border = {15, 15, 15, 255},
	TitleTop = {178, 178, 178, 255},
	TitleBottom = {153, 153, 153, 255},
	TitleText = {38, 38, 38, 255},

	CloseImage = love.graphics.newImage("gfx/gui/default/close.png"),
	CloseDefault = {180, 180, 180, 255},
	CloseHover = {255, 255, 255},

	Font = love.graphics.getFont(),
}

Desktop = {
	Font = love.graphics.getFont(),
	Cursor = love.mouse.getSystemCursor("arrow"),
}

Hint = {
	Background = {102, 102, 102, 191},
	Border = {15, 15, 15, 191},
	Text = {38, 38, 38, 191},
}

Button = {
	Border = {15, 15, 15, 255},

	Top = {178, 178, 178, 255},
	Bottom = {153, 153, 153, 255},
	Text = {38, 38, 38, 255},

	HoverTop = {218, 218, 218, 255},
	HoverBottom = {193, 193, 193, 255},
	HoverText = {78, 78, 78, 255},

	HoldTop = {158, 158, 158, 255},
	HoldBottom = {133, 133, 133, 255},
	HoldText = {18, 18, 18, 255},

	Font = love.graphics.getFont(),
	Cursor = love.mouse.getSystemCursor("hand"),
}

Slider = {
	Border = {15, 15, 15, 255},
	Background = {229, 229, 229, 255},
	Lines = {100, 100, 100, 255},

	Bar = {
		Border = {82, 82, 82, 255},
		Background = {204, 204, 204, 255},
		HoverBackground = {188, 188, 188, 255},
		HoldBackground = {173, 173, 173, 255},
	},
}

Checkbox = {
	Border = {15, 15, 15, 255},
	Background = {229, 229, 229, 255},
	HoverBackground = {255, 255, 255, 255},
	Text = {38, 38, 38, 255},

	MarkImage = love.graphics.newImage("gfx/gui/default/checkmark.png"),
	Font = love.graphics.getFont(),
}

Tabber = {
	Border = {15, 15, 15, 255},

	Top = {178, 178, 178, 255},
	Bottom = {153, 153, 153, 255},
	Text = {38, 38, 38, 255},

	HoverTop = {218, 218, 218, 255},
	HoverBottom = {193, 193, 193, 255},
	HoverText = {78, 78, 78, 255},

	HoldTop = {158, 158, 158, 255},
	HoldBottom = {133, 133, 133, 255},
	HoldText = {18, 18, 18, 255},

	Font = love.graphics.getFont(),
	Cursor = love.mouse.getSystemCursor("hand"),
}

Label = {
	Text = {38, 38, 38, 255},
	Font = love.graphics.getFont(),
}

Textfield = {
	Border = {15, 15, 15, 255},
	Background = {255, 255, 255, 255},
	Text = {38, 38, 38, 255},
	SelectedText = {100, 100, 100, 100},
	HintText = {100, 100, 100, 255},

	Font = love.graphics.getFont(),
	Cursor = love.mouse.getSystemCursor("ibeam"),
}

Image = {
	Background = {255, 255, 255, 255},
}

Listbox = {
	Border = {15, 15, 15, 255},
	Background = {255, 255, 255, 255},
	Text = {38, 38, 38, 255},
	Selected = {0, 0, 0, 60},
	Hover = {100, 100, 100, 60},

	Font = love.graphics.getFont(),
}

Combobox = {
	Border = {15, 15, 15, 255},
	Background = {255, 255, 255, 255},
	Text = {38, 38, 38, 255},
	Selected = {0, 0, 0, 60},
	Hover = {100, 100, 100, 60},
	
	Font = love.graphics.getFont(),
	Cursor = love.mouse.getSystemCursor("hand"),
	DropImage = love.graphics.newImage("gfx/gui/default/down.png"),
}

Combofield = {
	Border = {15, 15, 15, 255},
	Background = {255, 255, 255, 255},
	Text = {38, 38, 38, 255},
	Selected = {0, 0, 0, 60},
	Hover = {100, 100, 100, 60},
	
	SelectedText = {100, 100, 100, 100},
	HintText = {100, 100, 100, 255},
	
	Font = love.graphics.getFont(),
	HandCursor = love.mouse.getSystemCursor("hand"),
	TextCursor = love.mouse.getSystemCursor("ibeam"),
	DropImage = love.graphics.newImage("gfx/gui/default/down.png"),
}

Progressbar = {
	Border = {15, 15, 15, 255},
	Background = {120, 120, 120, 255},
	Top = {50, 255, 50, 255},
	Bottom = {25, 200, 25, 255},
	
	Text = {38, 38, 38, 255},
	
	Font = love.graphics.getFont()
}

Listview = {
	Border = {15, 15, 15, 255},
	Background = {255, 255, 255, 255},
	Text = {38, 38, 38, 255},
	Selected = {0, 0, 0, 60},
	Hover = {100, 100, 100, 60},
	Top = {178, 178, 178, 255},
	Bottom = {153, 153, 153, 255},

	Font = love.graphics.getFont(),
}

Textarea = {
	Border = {15, 15, 15, 255},
	Background = {255, 255, 255, 255},
	Text = {38, 38, 38, 255},
	SelectedText = {100, 100, 100, 100},
	SliderArea = {220, 220, 220, 255},

	Font = love.graphics.getFont(),
	Cursor = love.mouse.getSystemCursor("ibeam"),
}

Context = {
	Background = {220, 220, 220, 255},
	Border = {15, 15, 15, 255},
	Text = {38, 38, 38, 255},
	Hover = {100, 100, 100, 60},
	
	Font = love.graphics.getFont(),
	Cursor = love.mouse.getSystemCursor("hand"),
}

Panel = {
	Background = {230, 230, 230, 255},
	Border = {80, 80, 80, 255},
	Text = {38, 38, 38, 255},

	Font = love.graphics.getFont(),
}

RadioButton = {
	Background = {100, 100, 100, 255},
	HoverBackground = {150, 150, 150, 255},
	Border = {15, 15, 15, 255},
	Text = {38, 38, 38, 255},

	Font = love.graphics.getFont(),
}