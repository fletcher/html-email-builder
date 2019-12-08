# html-email-builder #

Workflow to build responsive HTML email via MultiMarkdown (and optionally upload to sendinblue.com)

Copyright (C) 2019 - Fletcher T. Penney


## Introduction ##

First, to be clear -- I hate junk mail.  I hate getting most marketing mail,
and am ruthless with the unsubscribe and spam buttons.  That said, I do on
very rare occasions need to send out an announcement to my customers.  It
always annoyed me that I didn't have a great workflow to use my own tools
(e.g. MultiMarkdown) to write those emails and had to rely instead on WYSIWYG
boxes on someone else' web site.

So I created this as an experiment to helping me automate the process a bit.


## Dependencies ##

Requires:

1. [MultiMarkdown]
2. [jq]


[MultiMarkdown]: https://github.com/fletcher/MultiMarkdown-6
[jq]: https://stedolan.github.io/jq/


## Usage ##

First, create a copy of `sample-config.json` to configure your email sender
information (e.g. name and email address).


`./build_html.sh your-config.json sample.md`

Using your email configuration file (`your_config.json`) and your
MultiMarkdown message (`sample.md`), this creates `sample.html` and
`sample.json`.  `sample.json` contains the settings needed to upload your
message to <http://sendinblue.com/> (which is optional). `sample.html` is the
compiled HTML file.

***NOTE***: It seems that email clients are roughly equivalent to 1990s or
early 2000s web browsers -- CSS does not work properly, and instead the
styling needs to be inlined into `style` attributes. 
<https://htmlemail.io/inline/> is one site that will do this for you.  Paste
the contents of `sample.html` into the top left box, and the converted HTML
will appear in the lower left box.  You can then replace the contents of
`sample.html` with the new text.  I'm looking at automating this, but am not
there yet.

Once you've inlined the CSS, the HTML file is ready to be sent.  If you are
using <http://sendinblue.com/>, you can now do the following.  If you use
another email marketing service that has an API, you can use this as an
example of how to configure a workflow for your service.

1.	You need your Sendinblue api key in the file `api.key` -- simply paste the
whole thing (it will look like `api-key:xkeysib-XXXXXXXXXXXXXX...`).  Delete
any trailing spaces or newlines.

2. Use `./upload-sendinblue.sh sample.json sample.html` to read the campaing
information and the HTML, and upload them.

3. Log into your <http://sendinblue.com/> account and you can review the
campaign, send a test email, and finally send out the actual campaign.


## Included CSS ##

The contents of `responsive-html-email-template.css`, `header.md` and
`footer.html` are derived from
<https://github.com/leemunroe/responsive-html-email-template>.  It is used as
an example of a responsive HTML/CSS setup that provides decent results.  You
may want to customize it to suit your needs, and there are plenty of other
examples out there.  This was one that I found that was simple to use and
provided a good base.  I made one change in lists because some email clients
(e.g. Gmail in Chrome) were causing list bullets to appear on one line, and
the contents to appear on the next line when using loose list items.

