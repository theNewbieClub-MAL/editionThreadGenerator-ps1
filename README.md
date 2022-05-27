<!-- markdownlint-disable MD033 MD034 MD036 -->

# The Newbie Club's Edition Thread Generator: PowerShell version

Tested on:

* :penguin: Zorin OS 12.1 (based on Ubuntu 20.04 LTS): PowerShell Core 7.2.4, Visual Studio Code Host 2022.5.1
* :computer: Windows 10 21H2: Windows PowerShell 5.1.19041

## Preface

Hello! :wave:

Welcome to The Newbie Club's Edition Thread Generator: Powershell version repository. This repo serves as automation script for generating [card release][cardFaq] threads for [The Newbie Club][tnc] on MyAnimeList. Anyone can use this script to generate threads for their own.

This project aims to write as native as possible during text generation: no external modules required to be installed, no need to run as admin for some steps, etc. The only external program we use is [Git][git] to clone the repo to your end machine.

Also the script should be cross-compatible with Windows Powershell 5 and UNIX-like system by encoding the file to UTF8-BOM and EOL to `LF`.

## Requirements and Prerequisites

1. Before you start, you need to make sure that:
   * Currently using Windows 10 or Windows Server 2016 or newer; supported Linux distributions: Debian, Ubuntu, CentOS, Fedora, Arch, OpenSUSE, and others; macOS 10.12 or newer.
   * PowerShell Core 7 or higher (recommended); Windows PowerShell 5.1 or higher
     * We recommend to select **LTS** or **Stable** for PowerShell Core.
   * **Exclusive for PowerShell on Windows**: Windows Terminal to render non-ASCII symbols correctly (recommended).
   * Git, or any 3rd party Git client, installed and configured.
   * Proper internet access, ~~and IP was not blocked by MAL because it's sucks~~.
2. You can install the related softwares by clicking the link below:
   * PowerShell: https://github.com/PowerShell/PowerShell
   * Windows Terminal: https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701
   * Git: https://git-scm.com/

## Setup

1. (Fork this repo and) clone the repo to your machine.
   * We prefer to clone with Git rather download the repo as a ZIP package.
   * To clone on Terminal, do:

    ```bash
    git clone https://github.com/theNewbieClub-MAL/editionThreadGenerator
    ```

     Make sure the working directory is `~/` on Linux/macOS, or `%USERPROFILE%` (`C:\Users\(Username)\`) on Windows.
2. Open PowerShell:
   * On Windows:
     * Press <kbd>Win</kbd>, and type PowerShell, or
     * Press <kbd>Win</kbd>, type Windows Terminal, and press <kbd>Enter</kbd>.
   * On UNIX-like system, open your favorite terminal and type `pwsh` or `powershell`.
3. Move your current working directory on PowerShell to the cloned repo.
   * On Windows, type `cd %USERPROFILE%\editionThreadGenerator-ps1` and press <kbd>Enter</kbd>.
   * On UNIX-like system, type `cd ~/editionThreadGenerator-ps1` and press <kbd>Enter</kbd>.
4. Run the script by typing `./script.ps1`.
5. If the script greeted you with `The Newbie Club: Card Edition Post Generator v.(x)`, you're good to go!

**Note**\
If your machine threw an error about ExecutionPolicy set to restricted on Windows, write this cmdlet:

```ps1
Set-ExecutionPolicy AllSigned
```

**or**

```ps1
Set-ExecutionPolicy Bypass -Scope Process
```

## Usage

1. Follows the steps from [#Setup](#setup).
2. [Select language] you prefer for prompt interface.
3. Answer all questions.
4. Copy the result to clipboard.
5. Done.

## Languages List

We offers the following languages for prompt interface:

* English (US) `en-US`, default
* Indonesian (Indonesia) `id-ID`, by nattadasu
* Melayu (Malaysia) `ms-MY`, by nattadasu

If you interested in translating this script, please follow steps on [#Contributing](#contributing).

## Contributing

### Pre-commit

1. Fork this repo and clone the repo to your machine.

   ```bash
    git clone https://github.com/<username>/editionThreadGenerator-ps1
    ```

### Translation

1. Open `Translations/` folder.
2. Duplicate `en-US/` folder and rename the duplicated folder to your language [culture code defined by Microsoft][cultureCode].
   * You can create your own language folder by following RFC 4646 specification:\
     `languageCode2`-`regionCode2`.
      For example:
      * `id-ID` for Indonesian (Indonesia).
   * If the language you covered have two-letter code not available, a three-letter code derived from ISO 639-2 is used.
      For example:
      * `ace-ID` for Acehnese (Indonesia).
   * If the language has script variant (ISO 15924), use pattern:\
      `languageCode2`-`scriptTag`-`regionCode2`.
      For example:
      * `uz-Cryl-UZ` for Uzbek (Cyrillic, Uzbekistan).
   * Neutral culture is accepted, however we discourage this method as it might cause confusion for the system to auto select culture.
   * The only exception of this name formatting only applies to:
     * `zh-Hant` for Traditional Chinese.
     * `zh-Hans` for Simplified Chinese.
3. Modify all the strings value in each `.psd1` files.
   * Due to `.psd1` safety restriction, the dynamic variables can not be assigned inside.
   * All of strings that have dynamic result follow this format:

     ```ps1
     $i18n.(Strings) $result
     ```

   * We recommend you to always check the grammar **on the script process**.

### Main script

*There is no strict guidelines, just keep avoid messing with variables, that's all*

### Commit and Pull Request

1. Add the modified files to your commit.
2. Name your commit.
   * For translation, please follow this format:

     ```xml
      Add/Modify <LanguageName> (<Country>) (<CultureCode>) Translation
      ```

3. Push your commit to your fork.
4. Open a pull request.

## License

This project is licensed under [MIT License][mit].

---

MIT License

Copyright (c) 2022 The Newbie Club

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


<!-- References -->
[cardFaq]: https://myanimelist.net/forum/?topicid=1983981
[cultureCode]: https://docs.microsoft.com/en-us/dotnet/api/system.globalization.cultureinfo?view=net-6.0#CultureNames
[git]: https://git-scm.com/
[mit]: LICENSE
[tnc]: https://myanimelist.net/clubs.php?cid=70668
