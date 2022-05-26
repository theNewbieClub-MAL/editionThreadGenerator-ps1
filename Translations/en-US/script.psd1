#culture=en-US
ConvertFrom-StringData @'
    InitLocale_General_echo     = 🌐 System automatically set the language for the script to
    InitLocale_General_prompt   = Do you want to change the language to else?
    InitLocale_List_echo        = Currently available languages:
    InitLocale_Replace_prompt   = 🔤 Write language code. Press enter/return key to keep the language
    InitLocale_Replace_success  = ✅ Successfuly changed the script language to

    Header_GeneralInfo          = General Information
    Header_Customizations       = Customizations
    Header_Intro                = Introduction
    Header_Cards                = Cards
    Header_Staff_1              = First Staff
    Header_Staff_2              = Second Staff
    Header_Staff_3              = Third Staff
    Header_Staff_4              = Fourth Staff
    Header_Staff_5              = Fifth Staff

    Question_Edition_Title      = 🔤 Edition Title
    Question_Edition_Emoji      = 😄 Edition Emoji, enter to skip
    Question_Edition_IsSingle   = ❓ Is the edition only covers one title? Default, n (y/n)
    Question_Edition_Count      = 🔢 Reply limit? Default, 100
    Question_Edition_Start      = 📆 Start Date, Format, YYYY-MM-DD; Sample:
    Question_Edition_End        = 📆 End Date, Format, YYYY-MM-DD; Sample:
    Question_Edition_Staff      = 👤 Total staff joined, Default, 1

    Question_Locale_Set         = 🌐 Which title format do you prefer? Default, romaji (romaji/english)
    Question_Locale_success     = ✅ Successfuly selected title format as:

    Question_Banner_Uri         = 🖼️  Banner URL
    Question_Banner_Title       = 🔤 Title of work used on banner
    Question_Banner_Creator     = 👤 MAL username of banner creator, without @ sign

    Question_Color              = 🖌️  Color of the thread in hex code with # sign, Sample, #FFFFFF; Default, #000000
    Question_DarkMode           = 🌙 Show dark mode warning? Default, y (y/n)

    Question_ID_Custom          = 🔗 Insert your custom url

    Question_Intro_GifUrl       = 🖼️  GIF Url for intro text
    Question_Intro_Text         = ✏️  Write the intro text. Use {{ and }} among text you want to color, and ^@ to new line

    Prompt_ToCopy               = 📋 Please select and copy the result:
    Prompt_MALId_Insert         = 🔢 Type MAL ID of the title, type 0 for custom input
    Prompt_Move_Section         = ⌨️  Type any keys to move to next section
    Prompt_Exit_Script          = ⌨️  Type any keys to exit

    Generate_Title_Success      = ✅ Successfuly generated the title
    Generate_Intro_Success      = ✅ Successfuly generated intro text as:
    Generate_BBCode_Success     = ✅ Successfuly generated BBCode post
    Generate_GFXRequest_Success = ✅ Successfuly generated GFX/Deliverer Request Corner post

    Attention_File_Created      = 💁 We also saved the generated file on `"./Generated.bbcode`", please to check it.

    Selected_Banner_Title       = ✅ Successfuly fetched proper title for banner from MAL as:
    Selected_Card_Title         = ✅ Successfuly fetched proper title for card from MAL as:

    Echo_ID_Custom              = You opted 0 for custom ID input. We accept: 1) MAL - anime, manga; 2) AniList - manga; 3) VNDB - Visual Novels; 4) IGDB - Game; 5) Wikipedia - General

    Staff_Username              = 👤 MAL Username
    Staff_Nickname              = 📛 Nickname
    Staff_Limit_Type            = ⚠️  Limit type? Default, role (role/any)
    Staff_Limit_Any             = 🔢 Card limit for any roles?
    Staff_Limit_Staff           = 🔢 Card limit for staff role?
    Staff_Limit_Member          = 🔢 Card limit for regular member?
    Staff_Limit_Total           = 🔢 Total card to be obtained?
    Staff_Cards_Url             = 🖼️  Card URL
    Staff_Cards_Title           = 🔤 Title of work used on card

    Invalid_Staff_Amount        = ❌ Invalid staff amount, automatically set to 5
    Invalid_Card_Amount         = ❌ Invalid card amount, automatically set to 9
'@
