<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><title>EmacsWiki: sr-speedbar.el</title><link rel="alternate" type="application/wiki" title="編輯本頁" href="https://www.emacswiki.org/emacs?action=edit;id=sr-speedbar.el" /><link type="text/css" rel="stylesheet" href="https://www.emacswiki.org/light.css" /><meta name="robots" content="INDEX,FOLLOW" /><link rel="alternate" type="application/rss+xml" title="EmacsWiki" href="https://www.emacswiki.org/emacs?action=rss" /><link rel="alternate" type="application/rss+xml" title="EmacsWiki: sr-speedbar.el" href="https://www.emacswiki.org/emacs?action=rss;rcidonly=sr-speedbar.el" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki with page content"
      href="https://www.emacswiki.org/full.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki with page content and diff"
      href="https://www.emacswiki.org/full-diff.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki including minor differences"
      href="https://www.emacswiki.org/minor-edits.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Changes for sr-speedbar.el only"
      href="https://www.emacswiki.org/emacs?action=rss;rcidonly=sr-speedbar.el" /><meta name="viewport" content="width=device-width" />
<script type="text/javascript" src="/outliner.0.5.0.62-toc.js"></script>
<script type="text/javascript">

  function addOnloadEvent(fnc) {
    if ( typeof window.addEventListener != "undefined" )
      window.addEventListener( "load", fnc, false );
    else if ( typeof window.attachEvent != "undefined" ) {
      window.attachEvent( "onload", fnc );
    }
    else {
      if ( window.onload != null ) {
	var oldOnload = window.onload;
	window.onload = function ( e ) {
	  oldOnload( e );
	  window[fnc]();
	};
      }
      else
	window.onload = fnc;
    }
  }

  // https://stackoverflow.com/questions/280634/endswith-in-javascript
  if (typeof String.prototype.endsWith !== 'function') {
    String.prototype.endsWith = function(suffix) {
      return this.indexOf(suffix, this.length - suffix.length) !== -1;
    };
  }

  var initToc=function() {

    var outline = HTML5Outline(document.body);
    if (outline.sections.length == 1) {
      outline.sections = outline.sections[0].sections;
    }

    if (outline.sections.length > 1
	|| outline.sections.length == 1
           && outline.sections[0].sections.length > 0) {

      var toc = document.getElementById('toc');

      if (!toc) {
	var divs = document.getElementsByTagName('div');
	for (var i = 0; i < divs.length; i++) {
	  if (divs[i].getAttribute('class') == 'toc') {
	    toc = divs[i];
	    break;
	  }
	}
      }

      if (!toc) {
	var h2 = document.getElementsByTagName('h2')[0];
	if (h2) {
	  toc = document.createElement('div');
	  toc.setAttribute('class', 'toc');
	  h2.parentNode.insertBefore(toc, h2);
	}
      }

      if (toc) {
        var html = outline.asHTML(true);
        toc.innerHTML = html;

	items = toc.getElementsByTagName('a');
	for (var i = 0; i < items.length; i++) {
	  while (items[i].textContent.endsWith('✎')) {
            var text = items[i].childNodes[0].nodeValue;
	    items[i].childNodes[0].nodeValue = text.substring(0, text.length - 1);
	  }
	}
      }
    }
  }

  addOnloadEvent(initToc);
  </script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head><body class="default"><div class="header"><a href="https://www.emacswiki.org/emacs/%e7%b6%b2%e7%ab%99%e5%9c%b0%e5%9c%96" class="logo"><img class="logo" src="https://www.emacswiki.org/images/logo218x38.png" alt="[首頁]" /></a><div class="menu"><span class="gotobar bar"><a href="https://www.emacswiki.org/emacs/%e7%b6%b2%e7%ab%99%e5%9c%b0%e5%9c%96" class="local">網站地圖</a> <a class="local" href="https://www.emacswiki.org/emacs/%e6%9c%80%e8%bf%91%e6%9b%b4%e6%96%b0">最近更新</a> <a class="local" href="https://www.emacswiki.org/emacs/News">News</a> <a href="https://www.emacswiki.org/emacs/ElispArea" class="local">ElispArea</a> <a href="https://www.emacswiki.org/emacs/%e6%95%99%e5%af%bc" class="local">教导</a> </span><form method="get" action="https://www.emacswiki.org/emacs" enctype="multipart/form-data" class="search" accept-charset="utf-8"><p><label for="search">搜尋：</label> <input type="text" name="search"  size="20" accesskey="f" id="search" /> <label for="searchlang">語文：</label> <input type="text" name="lang"  size="10" id="searchlang" /> <input type="submit" name="dosearch" value="開始！" /></p></form></div><h1><a href="https://www.emacswiki.org/emacs?search=%22sr-speedbar%5c.el%22" rel="nofollow" title="按下即可以搜尋參考至本頁的資料">sr-speedbar.el</a></h1></div><div class="wrapper"><div class="content browse"><p class="download"><a href="https://www.emacswiki.org/emacs/download/sr-speedbar.el">Download</a> <a href="https://github.com/emacsmirror/emacswiki.org/blob/master/sr-speedbar.el">Git</a> <a href="http://www.emacswiki.org/emacs/download/sr-speedbar.el">Homepage</a></p><pre><span class="comment">;;; sr-speedbar.el --- Same frame speedbar</span>

<span class="comment">;; Author: Sebastian Rose &lt;sebastian_rose@gmx.de&gt;</span>
<span class="comment">;; Maintainer: Sebastian Rose &lt;sebastian_rose@gmx.de&gt;</span>
<span class="comment">;;             Peter Lunicks &lt;plunix@users.sourceforge.net&gt;</span>
<span class="comment">;; Copyright (C) 2008, 2009, Sebastian Rose, all rights reserved.</span>
<span class="comment">;; Copyright (C) 2008, 2009, Andy Stewart, all rights reserved.</span>
<span class="comment">;; Copyright (C) 2009, Peter Lunicks, all rights reversed.</span>
<span class="comment">;; Created: 2008</span>
<span class="comment">;; Version: 20161025</span>
<span class="comment">;; X-Original-Version: 0.1.10</span>
<span class="comment">;; Last-Updated: 2016-10-25</span>
<span class="comment">;; URL: http://www.emacswiki.org/emacs/download/sr-speedbar.el</span>
<span class="comment">;; Keywords: speedbar, sr-speedbar.el</span>
<span class="comment">;; Compatibility: GNU Emacs 22 ~ GNU Emacs 25</span>
<span class="comment">;;</span>
<span class="comment">;; Features required by this library:</span>
<span class="comment">;;</span>
<span class="comment">;;  `<span class="constant important">speedbar</span>' `<span class="constant important">advice</span>' `<span class="constant important">cl</span>'</span>
<span class="comment">;;</span>

<span class="comment">;;; This file is NOT part of GNU Emacs</span>

<span class="comment">;;; License</span>
<span class="comment">;;</span>
<span class="comment">;; This program is free software; you can redistribute it and/or modify</span>
<span class="comment">;; it under the terms of the GNU General Public License as published by</span>
<span class="comment">;; the Free Software Foundation; either version 3, or (at your option)</span>
<span class="comment">;; any later version.</span>

<span class="comment">;; This program is distributed in the hope that it will be useful,</span>
<span class="comment">;; but WITHOUT ANY WARRANTY; without even the implied warranty of</span>
<span class="comment">;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the</span>
<span class="comment">;; GNU General Public License for more details.</span>

<span class="comment">;; You should have received a copy of the GNU General Public License</span>
<span class="comment">;; along with this program; see the file COPYING.  If not, write to</span>
<span class="comment">;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth</span>
<span class="comment">;; Floor, Boston, MA 02110-1301, USA.</span>

<span class="comment">;;; Commentary:</span>
<span class="comment">;;</span>
<span class="comment">;; The sr-speedbar.el was created just because I could not believe what I</span>
<span class="comment">;; read on http://www.emacswiki.org/cgi-bin/wiki/Speedbar.  They wrote there</span>
<span class="comment">;; that it is not possible to show the speedbar in the same frame.  But, as</span>
<span class="comment">;; we all know, ecb had this already.  So I started as some kind of joke :)</span>
<span class="comment">;; But when I found it useful and use it all the time.</span>
<span class="comment">;;</span>
<span class="comment">;; Now you type windows key with 's' (`<span class="constant important">s-s</span>' in Emacs) will show the speedbar</span>
<span class="comment">;; in an extra window, same frame.  You can customize the initial width of the</span>
<span class="comment">;; speedbar window.</span>
<span class="comment">;;</span>
<span class="comment">;; Below are commands you can use:</span>
<span class="comment">;;</span>
<span class="comment">;; `<span class="constant important">sr-speedbar-open</span>'                   Open `<span class="constant important">sr-speedbar</span>' window.</span>
<span class="comment">;; `<span class="constant important">sr-speedbar-close</span>'                  Close `<span class="constant important">sr-speedbar</span>' window.</span>
<span class="comment">;; `<span class="constant important">sr-speedbar-toggle</span>'                 Toggle `<span class="constant important">sr-speedbar</span>' window.</span>
<span class="comment">;; `<span class="constant important">sr-speedbar-select-window</span>'          Select `<span class="constant important">sr-speedbar</span>' window.</span>
<span class="comment">;; `<span class="constant important">sr-speedbar-refresh-turn-on</span>'        Turn on refresh speedbar content.</span>
<span class="comment">;; `<span class="constant important">sr-speedbar-refresh-turn-off</span>'       Turn off refresh speedbar content.</span>
<span class="comment">;; `<span class="constant important">sr-speedbar-refresh-toggle</span>'         Toggle refresh speedbar content.</span>
<span class="comment">;;</span>
<span class="comment">;; Enjoy! ;)</span>
<span class="comment">;;</span>

<span class="comment">;;; Installation:</span>
<span class="comment">;;</span>
<span class="comment">;; Copy sr-speedbar.el to your load-path and add to your ~/.emacs</span>
<span class="comment">;;</span>
<span class="comment">;;  (<span class="keyword">require</span> '<span class="constant">sr-speedbar</span>)</span>
<span class="comment">;;  (global-set-key (kbd <span class="string">"s-s"</span>) 'sr-speedbar-toggle)</span>
<span class="comment">;;</span>
<span class="comment">;; ... or any key binding you like.</span>
<span class="comment">;;</span>

<span class="comment">;;; Customize:</span>
<span class="comment">;;</span>
<span class="comment">;;      M-x customize-group RET sr-speedbar RET</span>

<span class="comment">;;; Change log:</span>
<span class="comment">;; * 25 Oct 2016:</span>
<span class="comment">;;   * Hong Xu &lt;hong@topbug.net&gt;</span>
<span class="comment">;;      * Fix compilation warning when `<span class="constant important">helm-alive-p</span>' is not defined.</span>
<span class="comment">;;</span>
<span class="comment">;; * 04 Aug 2015:</span>
<span class="comment">;;   * Tamas Levai &lt;levait@tmit.bme.hu&gt;:</span>
<span class="comment">;;      * fix compilation warnings</span>
<span class="comment">;;</span>
<span class="comment">;; * 15 Sep 2014:</span>
<span class="comment">;;   * Tu, Do Hoang &lt;tuhdo1710@gmail.com&gt;</span>
<span class="comment">;;      * define `<span class="constant important">sr-speedbar-handle-other-window-advice</span>' and `<span class="constant important">ad-advised-definition-p</span>'</span>
<span class="comment">;;      before defining `<span class="constant important">sr-speedbar-skip-other-window-p</span>'. Othewise, `<span class="constant important">sr-speedbar</span>'</span>
<span class="comment">;;      fails to load at this stage.</span>
<span class="comment">;;</span>
<span class="comment">;;      * Do not used advised `<span class="constant important">pop-to-buffer</span>' when helm window is</span>
<span class="comment">;;      alive. Otherwise another horizontal buffer is created inside</span>
<span class="comment">;;      Helm buffer.</span>
<span class="comment">;;</span>
<span class="comment">;;   * Uwe Koloska &lt;kolewu@koloro.de&gt;</span>
<span class="comment">;;      * define `<span class="constant important">ad-advised-definition-p</span>' only if it's not defined</span>
<span class="comment">;;        fixes an error on Emacs 24.3 where `<span class="constant important">macrop</span>' ist still named</span>
<span class="comment">;;        `<span class="constant important">ad-macro-p</span>'</span>
<span class="comment">;;</span>
<span class="comment">;; * 03 Aug 2014:</span>
<span class="comment">;;   * Reuben Thomas &lt;rrt@sc3d.org&gt;:</span>
<span class="comment">;;      * Reduce to a single width preference, and make it work properly on</span>
<span class="comment">;;        startup.</span>
<span class="comment">;;      * Miscellaneous tidying of documentation and comments.</span>
<span class="comment">;;      * Remove version constant; should be using the package header, and it</span>
<span class="comment">;;        was already way out of date.</span>
<span class="comment">;;</span>
<span class="comment">;; * 08 Jun 2014:</span>
<span class="comment">;;   * Gregor Zattler:</span>
<span class="comment">;;      * test if symbol `<span class="constant important">ad-advised-definition-p</span>' is defined,</span>
<span class="comment">;;        since Christian Brassats version test failed on emacs</span>
<span class="comment">;;        23.3.91.1</span>
<span class="comment">;;</span>
<span class="comment">;; * 05 May 2014:</span>
<span class="comment">;;   * Christian Brassat:</span>
<span class="comment">;;      * `<span class="constant important">ad-advised-definition-p</span>' is not supported since Emacs 24.4.</span>
<span class="comment">;;</span>
<span class="comment">;; * 09 Mar 2013:</span>
<span class="comment">;;   * Tharre:</span>
<span class="comment">;;      * Remove Emacs 21 compatibility code as it fails to compile on Emacs 24.</span>
<span class="comment">;;</span>
<span class="comment">;; * 20 July 2009:</span>
<span class="comment">;;   * Peter Lunicks:</span>
<span class="comment">;;      * Add new option `<span class="constant important">sr-speedbar-right-side</span>' to control which</span>
<span class="comment">;;        side of the frame the speedbar appears on.</span>
<span class="comment">;;</span>
<span class="comment">;; * 18 Feb 2009:</span>
<span class="comment">;;   * Andy Stewart:</span>
<span class="comment">;;      * Fix bug between ECB and `<span class="constant important">sr-speedbar-close</span>'.</span>
<span class="comment">;;</span>
<span class="comment">;; * 29 Jan 2009:</span>
<span class="comment">;;   * Andy Stewart:</span>
<span class="comment">;;      * Fix doc.</span>
<span class="comment">;;</span>
<span class="comment">;; * 13 Jan 2009:</span>
<span class="comment">;;   * Andy Stewart:</span>
<span class="comment">;;      * Use `<span class="constant important">emacs-major-version</span>' instead comment for Emacs 21 compatibility.</span>
<span class="comment">;;      * Rewrite advice for `<span class="constant important">pop-to-buffer</span>' to avoid `<span class="constant important">pop-to-buffer</span>' not effect</span>
<span class="comment">;;        when have many dedicated window in current frame.</span>
<span class="comment">;;      * Rewrite advice for `<span class="constant important">delete-other-windows</span>' to avoid use common variable</span>
<span class="comment">;;        `<span class="constant important">delete-protected-window-list</span>' and use `<span class="constant important">window-dedicated-p</span>' instead.</span>
<span class="comment">;;        Remove variable `<span class="constant important">delete-protected-window-list</span>' and function</span>
<span class="comment">;;        `<span class="constant important">sr-speedbar-dedicated-match-protected-window-p</span>'.</span>
<span class="comment">;;</span>
<span class="comment">;; * 04 Jan 2009:</span>
<span class="comment">;;   * Andy Stewart:</span>
<span class="comment">;;      * Add new option `<span class="constant important">sr-speedbar-auto-refresh</span>' control refresh content.</span>
<span class="comment">;;      * Add new functions:</span>
<span class="comment">;;        `<span class="constant important">sr-speedbar-refresh-turn-on</span>',</span>
<span class="comment">;;        `<span class="constant important">sr-speedbar-refresh-turn-off</span>',</span>
<span class="comment">;;        `<span class="constant important">sr-speedbar-refresh-toggle</span>'.</span>
<span class="comment">;;      * Fix doc.</span>
<span class="comment">;;</span>
<span class="comment">;; * 30 Dec 2008:</span>
<span class="comment">;;   * Andy Stewart:</span>
<span class="comment">;;      * Rewrite advice for `<span class="constant important">delete-other-windows</span>' for fix the bug</span>
<span class="comment">;;        with window configuration save and revert.</span>
<span class="comment">;;      * Rewrite advice for `<span class="constant important">delete-window</span>', now just remember window</span>
<span class="comment">;;        width before deleted, and can use `<span class="constant important">delete-window</span>' do same effect</span>
<span class="comment">;;        as command `<span class="constant important">sr-speedbar-close</span>'.</span>
<span class="comment">;;      * Add new option `<span class="constant important">sr-speedbar-max-width</span>'.</span>
<span class="comment">;;        Remember window width before hide, except larger than value of</span>
<span class="comment">;;        `<span class="constant important">sr-speedbar-max-width</span>'.</span>
<span class="comment">;;      * Add new variable `<span class="constant important">delete-protected-window-list</span>', for protected</span>
<span class="comment">;;        special window don't deleted.</span>
<span class="comment">;;        This variable is common for any extension that use dedicated</span>
<span class="comment">;;        window.</span>
<span class="comment">;;      * Fix doc.</span>
<span class="comment">;;</span>
<span class="comment">;; * 29 Dec 2008:</span>
<span class="comment">;;   * Andy Stewart:</span>
<span class="comment">;;      * Pick-up and refactory code that use `<span class="constant important">buffer-live-p</span>' or `<span class="constant important">window-live-p</span>',</span>
<span class="comment">;;        and replace with `<span class="constant important">sr-speedbar-buffer-exist-p</span>' and</span>
<span class="comment">;;        `<span class="constant important">sr-speedbar-window-exist-p</span>'.</span>
<span class="comment">;;      * Rename some function with prefix `<span class="constant important">sr-speedbar-</span>' to avoid</span>
<span class="comment">;;        conflict with other functions.</span>
<span class="comment">;;      * Pick-up the code that handle advice for `<span class="constant important">other-window</span>',</span>
<span class="comment">;;        and replace with function `<span class="constant important">sr-speedbar-handle-other-window-advice</span>'.</span>
<span class="comment">;;      * Clean up code, make more clear.</span>
<span class="comment">;;</span>
<span class="comment">;; * 21 Dec 2008:</span>
<span class="comment">;;   * Andy Stewart:</span>
<span class="comment">;;      * Fix the bug `<span class="constant important">sr-speedbar-open</span>' and `<span class="constant important">sr-speedbar-close</span>'.</span>
<span class="comment">;;      * Fix doc.</span>
<span class="comment">;;</span>
<span class="comment">;; * 20 Dec 2008</span>
<span class="comment">;;   * Andy Stewart:</span>
<span class="comment">;;      * Fix `<span class="constant important">ad-advised-definition-p</span>' error.</span>
<span class="comment">;;      * Fix doc.</span>
<span class="comment">;;</span>
<span class="comment">;; * 17 Dec 2008</span>
<span class="comment">;;   * Andy Stewart:</span>
<span class="comment">;;      * Add new option `<span class="constant important">sr-speedbar-skip-other-window-p</span>' and new advice</span>
<span class="comment">;;        for `<span class="constant important">other-window</span>', make user skip select `<span class="constant important">sr-speedbar</span>' window</span>
<span class="comment">;;        when use command `<span class="constant important">other-window</span>'.</span>
<span class="comment">;;      * Fix the name of advice, make more clear.</span>
<span class="comment">;;      * Fix the bug `<span class="constant important">sr-speedbar-select-window</span>' when no live window exist.</span>
<span class="comment">;;      * Fix doc.</span>
<span class="comment">;;</span>
<span class="comment">;; * 16 Dec 2008:</span>
<span class="comment">;;   * Andy Stewart:</span>
<span class="comment">;;      * Fix the bug of `<span class="constant important">sr-speedbar-refresh</span>', use `<span class="constant important">default-directory</span>'</span>
<span class="comment">;;        get refresh directory instead through function in `<span class="constant important">dired</span>'.</span>
<span class="comment">;;      * Fix `<span class="constant important">window-live-p</span>' bug, check window valid value before use</span>
<span class="comment">;;        `<span class="constant important">window-live-p</span>' test `<span class="constant important">sr-speedbar-window</span>'.</span>
<span class="comment">;;      * Fix `<span class="constant important">buffer-live-p</span>' bug, check buffer valid value before use</span>
<span class="comment">;;        `<span class="constant important">buffer-live-p</span>' test `<span class="constant important">speedbar-buffer</span>'.</span>
<span class="comment">;;      * Add advice `<span class="constant important">pop-to-buffer</span>' to make function `<span class="constant important">display-buffer</span>'</span>
<span class="comment">;;        can pop-up window when just have two windows (one is `<span class="constant important">sr-speedbar</span>'</span>
<span class="comment">;;        window) in current frame.</span>
<span class="comment">;;      * Add group `<span class="constant important">sr-speedbar</span>'.</span>
<span class="comment">;;        More better customize interface through `<span class="constant important">customize-group</span>'.</span>
<span class="comment">;;</span>
<span class="comment">;; * 28 Sep 2008:</span>
<span class="comment">;;   * Andy Stewart:</span>
<span class="comment">;;      * Fix a bug, when `<span class="constant important">sr-speedbar-toggle</span>' many times, window width</span>
<span class="comment">;;        will increment automatically.</span>
<span class="comment">;;      * Use around advices replace, make code simple.</span>
<span class="comment">;;      * Use `<span class="constant important">sr-speedbar-open</span>' replace `<span class="constant important">sr-speedbar-no-separate-frame</span>'.</span>
<span class="comment">;;      * Clean up code.</span>
<span class="comment">;;</span>
<span class="comment">;; * 28 Sep 2008:</span>
<span class="comment">;;   * Sebastian:</span>
<span class="comment">;;      * set `<span class="constant important">sr-speedbar-delete-windows</span>' to nil to avoid</span>
<span class="comment">;;        the removal of other windows.</span>
<span class="comment">;;</span>
<span class="comment">;; * 26 Jun 2008:</span>
<span class="comment">;;   * Sebastian:</span>
<span class="comment">;;      * Added Andy Stewart's patch to refresh the speedbar's contents.</span>
<span class="comment">;;        Thanks for this one!</span>
<span class="comment">;;</span>
<span class="comment">;; * Init:</span>
<span class="comment">;;   * Sebastian:</span>
<span class="comment">;;      * Added some lines to get it working:</span>
<span class="comment">;;      * splitting the window and remember it,</span>
<span class="comment">;;      * changing the way speedbar finds a file.</span>
<span class="comment">;;      * File view of speedbar is now working all right.</span>
<span class="comment">;;      * C-x 1 in other window deletes speedbar-window, just calling</span>
<span class="comment">;;        M-x sr-speedbar-no-separate-frame again is fine now.</span>
<span class="comment">;;      * Toggle speedbar works, width is save when toggling.</span>
<span class="comment">;;      * Recalculate speedbar width if window-width - speedbar-width &lt;= 0</span>
<span class="comment">;;      * Speedbar window is now dedicated to speedbar-buffer.</span>
<span class="comment">;;</span>

<span class="comment">;;; Acknowledgements:</span>
<span class="comment">;;</span>
<span class="comment">;;      All emacsers ... :)</span>
<span class="comment">;;</span>

<span class="comment">;;; Bug</span>
<span class="comment">;;</span>
<span class="comment">;;</span>

<span class="comment">;;; TODO</span>
<span class="comment">;;</span>
<span class="comment">;;</span>
<span class="comment">;;</span>

<span class="comment">;;; Require</span>
(<span class="keyword">require</span> '<span class="constant">speedbar</span>)
(<span class="keyword">require</span> '<span class="constant">advice</span>)
(<span class="keyword">require</span> '<span class="constant">cl-lib</span>)
(<span class="keyword elisp">eval-when-compile</span>
  (<span class="keyword">require</span> '<span class="constant">cl</span>))

<span class="comment">;;; Code:</span>

<span class="comment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; User Customization ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
(<span class="keyword">defgroup</span> <span class="type">sr-speedbar</span> nil
  <span class="string">"Same frame speedbar."</span>
  <span class="builtin">:group</span> 'speedbar)

(<span class="keyword">defcustom</span> <span class="variable">sr-speedbar-default-width</span> 40
  <span class="string">"Initial width of `<span class="constant important">sr-speedbar-window</span>' under window system."</span>
  <span class="builtin">:type</span> 'integer
  <span class="builtin">:group</span> 'sr-speedbar)

(<span class="keyword">defcustom</span> <span class="variable">sr-speedbar-max-width</span> 50
  <span class="string">"The max width limit that window allowed.
Default, if hide `<span class="constant important">sr-speedbar</span>' window will remember
window width, except the window width larger than
this value."</span>
  <span class="builtin">:type</span> 'integer
  <span class="builtin">:group</span> 'sr-speedbar)

(<span class="keyword">defcustom</span> <span class="variable">sr-speedbar-auto-refresh</span> t
  <span class="string">"Automatically refresh speedbar content when changed directory.
Default is t."</span>
  <span class="builtin">:type</span> 'boolean
  <span class="builtin">:set</span> (<span class="keyword elisp">lambda</span> (symbol value)
         (set symbol value))
  <span class="builtin">:group</span> 'sr-speedbar)

(<span class="keyword">defcustom</span> <span class="variable">sr-speedbar-right-side</span> t
  <span class="string">"Show the speedbar to the right side of the current window.
If nil, the speedbar will appear on the left.
Default is t."</span>
  <span class="builtin">:type</span> 'boolean
  <span class="builtin">:set</span> (<span class="keyword elisp">lambda</span> (symbol value)
         (set symbol value))
  <span class="builtin">:group</span> 'sr-speedbar)

(<span class="keyword">defcustom</span> <span class="variable">sr-speedbar-delete-windows</span> nil
  <span class="string">"Allow the speedbar to delete other windows before showing up.
If nil, speedbar will not touch your window configuration.
Otherwise `<span class="constant important">delete-other-windows</span>' will be called before showing
the speedbar.

Default is nil."</span>
  <span class="builtin">:type</span> 'boolean
  <span class="builtin">:group</span> 'sr-speedbar)

(<span class="keyword elisp">if</span> (not (fboundp 'ad-advised-definition-p))
    (<span class="keyword">defun</span> <span class="function">ad-advised-definition-p</span> (definition)
      <span class="string">"Return non-nil if DEFINITION was generated from advice information."</span>
      (<span class="keyword elisp">if</span> (or (ad-lambda-p definition)
              (macrop definition)
              (ad-compiled-p definition))
          (<span class="keyword elisp">let</span> ((docstring (ad-docstring definition)))
            (and (stringp docstring)
                 (get-text-property 0 'dynamic-docstring-function docstring))))))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-handle-other-window-advice</span> (activate)
  <span class="string">"Handle advice for function `<span class="constant important">other-window</span>'.
If ACTIVATE is `<span class="constant important">non-nil</span>' enable advice `<span class="constant important">sr-speedbar-other-window-advice</span>'.
Otherwise disable it."</span>
  (<span class="keyword elisp">if</span> activate
      (ad-enable-advice 'other-window 'after 'sr-speedbar-other-window-advice)
    (ad-disable-advice 'other-window 'after 'sr-speedbar-other-window-advice))
  (ad-activate 'other-window))

(<span class="keyword">defcustom</span> <span class="variable">sr-speedbar-skip-other-window-p</span> nil
  <span class="string">"Whether skip `<span class="constant important">sr-speedbar</span>' window with `<span class="constant important">other-window</span>'.
Default, can use `<span class="constant important">other-window</span>' select window in cyclic
ordering of windows.  But sometimes we don't want select
`<span class="constant important">sr-speedbar</span>' window use `<span class="constant important">other-window</span>'.
Just want make `<span class="constant important">sr-speedbar</span>' window as a view sidebar.

So please turn on this option if you want skip
`<span class="constant important">sr-speedbar</span>' window with `<span class="constant important">other-window</span>'.

Default is nil."</span>
  <span class="builtin">:type</span> 'boolean
  <span class="builtin">:set</span> (<span class="keyword elisp">lambda</span> (symbol value)
         (set symbol value)
         (<span class="keyword elisp">if</span> (fboundp 'ad-advised-definition-p)
             (<span class="keyword cl">when</span> (ad-advised-definition-p 'other-window)
               (sr-speedbar-handle-other-window-advice value))
           (<span class="keyword cl">when</span> (ad-is-advised 'other-window)
             (sr-speedbar-handle-other-window-advice value))))
  <span class="builtin">:group</span> 'sr-speedbar)

<span class="comment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Constant ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
(<span class="keyword">defconst</span> <span class="variable">sr-speedbar-buffer-name</span> <span class="string">"*SPEEDBAR*"</span>
  <span class="string">"The buffer name of sr-speedbar."</span>)

<span class="comment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
(<span class="keyword">defvar</span> <span class="variable">sr-speedbar-width</span> sr-speedbar-default-width
  <span class="string">"Initial width of speedbar-window."</span>)

(<span class="keyword">defvar</span> <span class="variable">sr-speedbar-window</span> nil
  <span class="string">"Speedbar window."</span>)

(<span class="keyword">defvar</span> <span class="variable">sr-speedbar-last-refresh-dictionary</span> nil
  <span class="string">"The last refresh dictionary record of 'sr-speedbar-refresh'."</span>)

(<span class="keyword elisp">eval-when-compile</span>
  (<span class="keyword">defvar</span> <span class="variable">ecb-activated-window-configuration</span> nil)
  (<span class="keyword">defun</span> <span class="function">ecb-activate</span> ())
  (<span class="keyword">defun</span> <span class="function">ecb-deactivate</span> ()))

<span class="comment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Interactive functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
<span class="comment">;;;###<span class="warning">autoload</span></span>
(<span class="keyword">defun</span> <span class="function">sr-speedbar-toggle</span> ()
  <span class="string">"Toggle sr-speedbar window.
Toggle visibility of sr-speedbar by resizing
the `<span class="constant important">sr-speedbar-window</span>' to a minimal width
or the last width when visible.
Use this function to create or toggle visibility
of a speedbar-window.  It will be created if necessary."</span>
  (interactive)
  (<span class="keyword elisp">if</span> (sr-speedbar-exist-p)
      (sr-speedbar-close)
    (sr-speedbar-open)))

<span class="comment">;;;###<span class="warning">autoload</span></span>
(<span class="keyword">defun</span> <span class="function">sr-speedbar-open</span> ()
  <span class="string">"Create `<span class="constant important">sr-speedbar</span>' window."</span>
  (interactive)
  (<span class="keyword elisp">if</span> (not (sr-speedbar-exist-p))
      (<span class="keyword elisp">let</span> ((current-window (selected-window)))
        <span class="comment">;; Ensure only one window is there</span>
        <span class="comment">;; when `<span class="constant important">sr-speedbar-delete-windows</span>' is non-nil</span>
        (<span class="keyword elisp">if</span> sr-speedbar-delete-windows
            (delete-other-windows))
        <span class="comment">;; Whether activate `<span class="constant important">other-window</span>' advice</span>
        <span class="comment">;; to skip `<span class="constant important">sr-speedbar</span>' window when use `<span class="constant important">other-window</span>'.</span>
        (sr-speedbar-handle-other-window-advice sr-speedbar-skip-other-window-p)
        <span class="comment">;; Switch buffer</span>
        (<span class="keyword elisp">if</span> (sr-speedbar-buffer-exist-p speedbar-buffer)
            (<span class="keyword cl">unless</span> (sr-speedbar-window-exist-p sr-speedbar-window)
              (sr-speedbar-get-window))
          (<span class="keyword elisp">if</span> (&lt;= (sr-speedbar-current-window-take-width) sr-speedbar-width)
              (setq sr-speedbar-width sr-speedbar-default-width))
          (sr-speedbar-get-window)             <span class="comment">;get `<span class="constant important">sr-speedbar</span>' window that split current window</span>
          (setq speedbar-buffer (get-buffer-create sr-speedbar-buffer-name)
                speedbar-frame (selected-frame)
                dframe-attached-frame (selected-frame)
                speedbar-select-frame-method 'attached
                speedbar-verbosity-level 0 <span class="comment">;don't say anything, i don't like ... :)</span>
                speedbar-last-selected-file nil)
          (set-buffer speedbar-buffer)
          (buffer-disable-undo speedbar-buffer) <span class="comment">;make disable in speedbar buffer, otherwise will occur `<span class="constant important">undo-outer-limit</span>' error</span>
          (speedbar-mode)
          (speedbar-reconfigure-keymaps)
          (speedbar-update-contents)
          (speedbar-set-timer 1)
          <span class="comment">;; Add speedbar hook.</span>
          (add-hook 'speedbar-before-visiting-file-hook 'sr-speedbar-before-visiting-file-hook t)
          (add-hook 'speedbar-before-visiting-tag-hook 'sr-speedbar-before-visiting-tag-hook t)
          (add-hook 'speedbar-visiting-file-hook 'sr-speedbar-visiting-file-hook t)
          (add-hook 'speedbar-visiting-tag-hook 'sr-speedbar-visiting-tag-hook t)
          <span class="comment">;; Add `<span class="constant important">kill-buffer-hook</span>'.</span>
          (add-hook 'kill-buffer-hook 'sr-speedbar-kill-buffer-hook) <span class="comment">;add `<span class="constant important">kill-buffer-hook</span>'</span>
          <span class="comment">;; Auto refresh speedbar content</span>
          <span class="comment">;; if option `<span class="constant important">sr-speedbar-auto-refresh</span>' is non-nil</span>
          (sr-speedbar-handle-auto-refresh sr-speedbar-auto-refresh))
        (set-window-buffer sr-speedbar-window (get-buffer sr-speedbar-buffer-name))
        (set-window-dedicated-p sr-speedbar-window t) <span class="comment">;make `<span class="constant important">sr-speedbar-window</span>' dedicated to speedbar-buffer.</span>
        (select-window current-window))
    (message <span class="string">"`<span class="constant important">sr-speedbar</span>' window has exist."</span>)))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-close</span> ()
  <span class="string">"Close `<span class="constant important">sr-speedbar</span>' window and save window width."</span>
  (interactive)
  (<span class="keyword elisp">if</span> (sr-speedbar-exist-p)
      (<span class="keyword elisp">let</span> ((current-window (selected-window)))
        <span class="comment">;; Remember window width.</span>
        (sr-speedbar-select-window)
        (sr-speedbar-remember-window-width)
        <span class="comment">;; Close window.</span>
        (<span class="keyword elisp">if</span> (and (<span class="keyword">require</span> '<span class="constant">ecb</span> nil t)
                 ecb-activated-window-configuration)
            <span class="comment">;; Toggle ECB window when ECB window activated.</span>
            (<span class="keyword elisp">progn</span>
              (ecb-deactivate)
              (ecb-activate))
          <span class="comment">;; Otherwise delete dedicated window.</span>
          (delete-window sr-speedbar-window)
          (<span class="keyword elisp">if</span> (sr-speedbar-window-exist-p current-window)
              (select-window current-window))))
    (message <span class="string">"`<span class="constant important">sr-speedbar</span>' window is not exist."</span>)))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-select-window</span> ()
  <span class="string">"Force the windows that contain `<span class="constant important">sr-speedbar</span>'."</span>
  (interactive)
  (<span class="keyword elisp">if</span> (sr-speedbar-exist-p)
      (select-window sr-speedbar-window)
    (message <span class="string">"`<span class="constant important">sr-speedbar</span>' window is not exist."</span>)))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-refresh-turn-on</span> ()
  <span class="string">"Turn on refresh content automatically."</span>
  (interactive)
  (setq sr-speedbar-auto-refresh t)
  (sr-speedbar-handle-auto-refresh sr-speedbar-auto-refresh t))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-refresh-turn-off</span> ()
  <span class="string">"Turn off refresh content automatically."</span>
  (interactive)
  (setq sr-speedbar-auto-refresh nil)
  (sr-speedbar-handle-auto-refresh sr-speedbar-auto-refresh t))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-refresh-toggle</span> ()
  <span class="string">"Toggle refresh content status."</span>
  (interactive)
  (setq sr-speedbar-auto-refresh (not sr-speedbar-auto-refresh))
  (sr-speedbar-handle-auto-refresh sr-speedbar-auto-refresh t))

<span class="comment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; utilise functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
(<span class="keyword">defun</span> <span class="function">sr-speedbar-exist-p</span> ()
  <span class="string">"Return `<span class="constant important">non-nil</span>' if `<span class="constant important">sr-speedbar</span>' is exist.
Otherwise return nil."</span>
  (and (sr-speedbar-buffer-exist-p speedbar-buffer)
       (sr-speedbar-window-exist-p sr-speedbar-window)))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-window-p</span> ()
  <span class="string">"Return `<span class="constant important">non-nil</span>' if current window is `<span class="constant important">sr-speedbar</span>' window.
Otherwise return nil."</span>
  (equal sr-speedbar-buffer-name (buffer-name (window-buffer))))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-remember-window-width</span> ()
  <span class="string">"Remember window width."</span>
  (<span class="keyword elisp">let</span> ((win-width (sr-speedbar-current-window-take-width)))
    (<span class="keyword elisp">if</span> (and (sr-speedbar-window-p)
             (&gt; win-width 1)
             (&lt;= win-width sr-speedbar-max-width))
        (setq sr-speedbar-width win-width))))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-get-window</span> ()
  <span class="string">"Get `<span class="constant important">sr-speedbar</span>' window."</span>
  (<span class="keyword elisp">let</span> ((current-window (selected-window))
        <span class="comment">;; Get split new window.</span>
        (new-window (split-window
                     (selected-window)
                     (<span class="keyword elisp">if</span> sr-speedbar-right-side
                         (- (sr-speedbar-current-window-take-width) sr-speedbar-width)
                       sr-speedbar-width)
                     t)))
    <span class="comment">;; Select split window.</span>
    (setq sr-speedbar-window
          (<span class="keyword elisp">if</span> sr-speedbar-right-side
              <span class="comment">;; Select right window when `<span class="constant important">sr-speedbar-right-side</span>' is enable.</span>
              new-window
            <span class="comment">;; Otherwise select left widnow.</span>
            current-window))))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-before-visiting-file-hook</span> ()
  <span class="string">"Function that hook `<span class="constant important">speedbar-before-visiting-file-hook</span>'."</span>
  (select-window (previous-window)))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-before-visiting-tag-hook</span> ()
  <span class="string">"Function that hook `<span class="constant important">speedbar-before-visiting-tag-hook</span>'."</span>
  (select-window (previous-window)))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-visiting-file-hook</span> ()
  <span class="string">"Function that hook `<span class="constant important">speedbar-visiting-file-hook</span>'."</span>
  (select-window (previous-window)))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-visiting-tag-hook</span> ()
  <span class="string">"Function that hook `<span class="constant important">speedbar-visiting-tag-hook</span>'."</span>
  (select-window (previous-window)))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-kill-buffer-hook</span> ()
  <span class="string">"Function that hook `<span class="constant important">kill-buffer-hook</span>'."</span>
  (<span class="keyword cl">when</span> (eq (current-buffer) speedbar-buffer)
    (setq speedbar-frame nil
          dframe-attached-frame nil
          speedbar-buffer nil)
    (speedbar-set-timer nil)
    (remove-hook 'speedbar-before-visiting-file-hook 'sr-speedbar-before-visiting-file-hook)
    (remove-hook 'speedbar-before-visiting-tag-hook 'sr-speedbar-before-visiting-tag-hook)
    (remove-hook 'speedbar-visiting-file-hook 'sr-speedbar-visiting-file-hook)
    (remove-hook 'speedbar-visiting-tag-hook 'sr-speedbar-visiting-tag-hook)))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-refresh</span> ()
  <span class="string">"Refresh the context of speedbar."</span>
  (<span class="keyword cl">when</span> (and (not (equal default-directory sr-speedbar-last-refresh-dictionary)) <span class="comment">;if directory is change</span>
             (not (sr-speedbar-window-p))) <span class="comment">;and is not in speedbar buffer</span>
    (setq sr-speedbar-last-refresh-dictionary default-directory)
    (speedbar-refresh)))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-handle-auto-refresh</span> (activate <span class="type">&amp;optional</span> echo-show)
  <span class="string">"Automatically refresh speedbar content when changed directory.
Do nothing if option ACTIVATE is nil.
Will display message if ECHO-SHOW is non-nil."</span>
  (<span class="keyword elisp">if</span> activate
      (<span class="keyword elisp">progn</span>
        (add-hook 'speedbar-timer-hook 'sr-speedbar-refresh)
        (<span class="keyword elisp">if</span> echo-show (message <span class="string">"Turn on speedbar content refresh automatically."</span>)))
    (remove-hook 'speedbar-timer-hook 'sr-speedbar-refresh)
    (<span class="keyword elisp">if</span> echo-show (message <span class="string">"Turn off speedbar content refresh automatically."</span>))))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-current-window-take-width</span> (<span class="type">&amp;optional</span> window)
  <span class="string">"Return the width that WINDOW take up.
If WINDOW is nil, get current window."</span>
  (<span class="keyword elisp">let</span> ((edges (window-edges window)))
    (- (nth 2 edges) (nth 0 edges))))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-window-dedicated-only-one-p</span> ()
  <span class="string">"Only have one non-dedicated window."</span>
  (interactive)
  (<span class="keyword elisp">let</span> ((window-number 0)
        (dedicated-window-number 0))
    (walk-windows
     (<span class="keyword elisp">lambda</span> (w)
       (<span class="keyword elisp">with-selected-window</span> w
         (incf window-number)
         (<span class="keyword elisp">if</span> (window-dedicated-p w)
             (incf dedicated-window-number)))))
    (<span class="keyword elisp">if</span> (and (&gt; dedicated-window-number 0)
             (= (- window-number dedicated-window-number) 1))
        t nil)))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-window-exist-p</span> (window)
  <span class="string">"Return `<span class="constant important">non-nil</span>' if WINDOW is exist.
Otherwise return nil."</span>
  (and window (window-live-p window)))

(<span class="keyword">defun</span> <span class="function">sr-speedbar-buffer-exist-p</span> (buffer)
  <span class="string">"Return `<span class="constant important">non-nil</span>' if BUFFER is exist.
Otherwise return nil."</span>
  (and buffer (buffer-live-p buffer)))

<span class="comment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Advices ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
(<span class="keyword">defadvice</span> <span class="function">delete-other-windows</span> (around sr-speedbar-delete-other-window-advice activate)
  <span class="string">"This advice to make `<span class="constant important">sr-speedbar</span>' window can't deleted by command `<span class="constant important">delete-other-windows</span>'."</span>
  (<span class="keyword elisp">let</span> ((sr-speedbar-active-p (sr-speedbar-window-exist-p sr-speedbar-window)))
    (<span class="keyword elisp">if</span> sr-speedbar-active-p
        (<span class="keyword elisp">let</span> ((current-window (selected-window)))
          (<span class="keyword cl">dolist</span> (win (window-list))
            (<span class="keyword cl">when</span> (and (window-live-p win)
                       (not (eq current-window win))
                       (not (window-dedicated-p win)))
              (delete-window win))))
      ad-do-it)))

(<span class="keyword">defadvice</span> <span class="function">delete-window</span> (before sr-speedbar-delete-window-advice activate)
  <span class="string">"This advice to remember `<span class="constant important">sr-speedbar</span>' window width before deleted.
Use `<span class="constant important">delete-window</span>' delete `<span class="constant important">sr-speedbar</span>' window have same effect as `<span class="constant important">sr-speedbar-close</span>'."</span>
  <span class="comment">;; Remember window width before deleted.</span>
  (sr-speedbar-remember-window-width))

(<span class="keyword">defadvice</span> <span class="function">pop-to-buffer</span> (before sr-speedbar-pop-to-buffer-advice activate)
  <span class="string">"This advice is to fix `<span class="constant important">pop-to-buffer</span>' problem with dedicated window.
Default, function `<span class="constant important">display-buffer</span>' can't display buffer in select window
if current window is `<span class="constant important">dedicated</span>'.

So function `<span class="constant important">display-buffer</span>' conflict with `<span class="constant important">sr-speedbar</span>' window, because
`<span class="constant important">sr-speedbar</span>' window is `<span class="constant important">dedicated</span>' window.

That is to say, when current frame just have one `<span class="constant important">non-dedicated</span>' window,
any functions that use `<span class="constant important">display-buffer</span>' can't split windows
to display buffer, even option `<span class="constant important">pop-up-windows</span>' is enable.

And the example function that can occur above problem is `<span class="constant important">pop-to-buffer</span>'."</span>
  (<span class="keyword cl">when</span> (and pop-up-windows                            <span class="comment">;`<span class="constant important">pop-up-windows</span>' is enable</span>
             (sr-speedbar-window-dedicated-only-one-p) <span class="comment">;just have one `<span class="constant important">non-dedicated</span>' window</span>
             (sr-speedbar-window-exist-p sr-speedbar-window)
             (not (sr-speedbar-window-p)) <span class="comment">;not in `<span class="constant important">sr-speedbar</span>' window</span>
             (not (bound-and-true-p helm-alive-p)))
    (split-window-vertically)
    (windmove-down)))

(<span class="keyword">defadvice</span> <span class="function">other-window</span> (after sr-speedbar-other-window-advice)
  <span class="string">"Default, can use `<span class="constant important">other-window</span>' select window in cyclic ordering of windows.
But sometimes we don't want select `<span class="constant important">sr-speedbar</span>' window use `<span class="constant important">other-window</span>'.
Just want make `<span class="constant important">sr-speedbar</span>' window as a view sidebar.

This advice can make `<span class="constant important">other-window</span>' skip `<span class="constant important">sr-speedbar</span>' window."</span>
  (<span class="keyword elisp">let</span> ((count (or (ad-get-arg 0) 1)))
    (<span class="keyword cl">when</span> (and (sr-speedbar-window-exist-p sr-speedbar-window)
               (eq sr-speedbar-window (selected-window)))
      (other-window count))))

(<span class="keyword">provide</span> '<span class="constant">sr-speedbar</span>)

<span class="comment">;;; sr-speedbar.el ends here</span></pre></div><div class="wrapper close"></div></div><div class="footer"><hr /><span class="translation bar"><br />  <a href="https://www.emacswiki.org/emacs?action=translate;id=sr-speedbar.el;missing=de_es_fr_it_ja_ko_pt_ru_se_uk_zh" rel="nofollow" class="translation new">Add Translation</a></span><div class="edit bar"><a href="https://www.emacswiki.org/emacs/Comments_on_sr-speedbar.el" class="comment local" accesskey="c">讨论</a> <a rel="nofollow" title="按此即可編輯此頁面" class="edit" accesskey="e" href="https://www.emacswiki.org/emacs?action=edit;id=sr-speedbar.el">編輯本頁</a> <a rel="nofollow" class="history" href="https://www.emacswiki.org/emacs?action=history;id=sr-speedbar.el">參閱其他版本</a> <a rel="nofollow" class="admin" href="https://www.emacswiki.org/emacs?action=admin;id=sr-speedbar.el">管理 Oddmuse</a></div><div class="time">最後編輯於 2016-10-25 08:31 UTC 由 <a href="https://www.emacswiki.org/emacs/xuhdev" class="author" title="104.32.170.214">xuhdev</a> <a rel="nofollow" class="diff" href="https://www.emacswiki.org/emacs?action=browse;diff=2;id=sr-speedbar.el">(比較差異)</a></div><div style="float:right; margin-left:1ex;">
<!-- Creative Commons License -->
<a class="licence" href="https://creativecommons.org/licenses/GPL/2.0/"><img alt="CC-GNU GPL" style="border:none" src="/pics/cc-GPL-a.png" /></a>
<!-- /Creative Commons License -->
</div>

<!--
<rdf:RDF xmlns="http://web.resource.org/cc/"
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<Work rdf:about="">
   <license rdf:resource="https://creativecommons.org/licenses/GPL/2.0/" />
  <dc:type rdf:resource="http://purl.org/dc/dcmitype/Software" />
</Work>

<License rdf:about="https://creativecommons.org/licenses/GPL/2.0/">
   <permits rdf:resource="http://web.resource.org/cc/Reproduction" />
   <permits rdf:resource="http://web.resource.org/cc/Distribution" />
   <requires rdf:resource="http://web.resource.org/cc/Notice" />
   <permits rdf:resource="http://web.resource.org/cc/DerivativeWorks" />
   <requires rdf:resource="http://web.resource.org/cc/ShareAlike" />
   <requires rdf:resource="http://web.resource.org/cc/SourceCode" />
</License>
</rdf:RDF>
-->

<p class="legal">
This work is licensed to you under version 2 of the
<a href="https://www.gnu.org/">GNU</a> <a href="/GPL">General Public License</a>.
Alternatively, you may choose to receive this work under any other
license that grants the right to use, copy, modify, and/or distribute
the work, as long as that license imposes the restriction that
derivative works have to grant the same rights and impose the same
restriction. For example, you may choose to receive this work under
the
<a href="https://www.gnu.org/">GNU</a>
<a href="/FDL">Free Documentation License</a>, the
<a href="https://creativecommons.org/">CreativeCommons</a>
<a href="https://creativecommons.org/licenses/sa/1.0/">ShareAlike</a>
License, the XEmacs manual license, or
<a href="/OLD">similar licenses</a>.
</p>
<p class="legal" style="padding-top: 0.5em">Please note our <a href="Privacy">Privacy Statement</a>.</p>
</div>
</body>
</html>
