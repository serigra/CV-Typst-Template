#import "@preview/fontawesome:0.1.1": *

//------------------------------------------------------------------------------
// Style
//------------------------------------------------------------------------------

// const color
#let color-darknight = rgb("#131A28")
#let color-darkgray = rgb("#333333")
#let color-middledarkgray = rgb("#414141")
#let color-gray = rgb("#757575")
#let color-lightgray = rgb("#999999")
#let color-lightgreen = rgb("#23534799")
#let color-mediumgreen = rgb("#235347CC")
#let color-darkgreen = rgb("#1E4A40")
#let color-neon = rgb("#cfff04")
#let color-pink = rgb("#FA2FBD")

// Default style
#let color-accent-default = rgb("#235347")
#let font-header-default = ("Petrone", "Arial", "Helvetica", "Dejavu Sans")
#let font-text-default = ("Source Sans Pro", "Arial", "Helvetica", "Dejavu Sans")
#let align-header-default = center

// User defined style
$if(style.color-accent)$
#let color-accent = rgb("$style.color-accent$")
$else$
#let color-accent = color-accent-default
$endif$
$if(style.font-header)$
#let font-header = "$style.font-header$"
$else$
#let font-header = font-header-default
$endif$
$if(style.font-text)$
#let font-text = "$style.font-text$"
$else$
#let font-text = font-text-default
$endif$


//------------------------------------------------------------------------------
// Helper functions (from https://github.com/kazuyanagimoto/quarto-awesomecv-typst#readme)
//------------------------------------------------------------------------------


// icon string parser

#let parse_icon_string(icon_string) = {
  if icon_string.starts-with("fa ") [
    #let parts = icon_string.split(" ")
    #if parts.len() == 2 {
      fa-icon(parts.at(1), fill: color-lightgreen)
    } else if parts.len() == 3 and parts.at(1) == "brands" {
      fa-icon(parts.at(2), fa-set: "Brands", fill: color-lightgreen)
    } else {
      assert(false, "Invalid fontawesome icon string")
    }
  ] else if icon_string.ends-with(".svg") [
    #box(image(icon_string))
  ] else {
    assert(false, "Invalid icon string")
  }
}

// contaxt text parser
#let unescape_text(text) = {
  // This is not a perfect solution
  text.replace("\\", "").replace(".~", ". ")
}


// layout utility
#let __justify_align_1(left_body, right_body) = {
  block[
    #box(width: 3fr)[#left_body]
    #box(width: 2fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

#let __justify_align_2(left_body, right_body) = {
  block[
    #box(width: 4.8fr)[#left_body]
    #box(width: 0.2fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

#let __justify_align_3(left_body, mid_body, right_body) = {
  block[
    #box(width: 1fr)[
      #align(left)[
        #left_body
      ]
    ]
    #box(width: 1fr)[
      #align(center)[
        #mid_body
      ]
    ]
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

/// Right section for the justified headers
/// - body (content): The body of the right header
#let secondary-right-header(body) = {
  set text(
    size: 9pt,
    weight: "thin",
    //style: "italic",
    fill: color-lightgray,
  )
  body
}

/// Right section of a tertiaty headers. 
/// - body (content): The body of the right header
#let tertiary-right-header(body) = {
  set text(
    size: 9pt,
    weight: "light",
    //style: "italic",
    fill: color-lightgray,
  )
  body
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let justified-header(primary, secondary) = {
  set block(
    above: 0.9em,
    below: 1.1em,
  )
  pad[
    #__justify_align_1[
      #set text(
        size: 12pt,
        weight: "bold",
        fill: color-darkgreen,
      )
      #primary
    ][
      #secondary-right-header[#secondary]
    ]
  ]
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right. This is a smaller header compared to the `justified-header`.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let secondary-justified-header(primary, secondary) = {
  __justify_align_2[
     #set text(
      size: 10pt,
      weight: "regular",
      fill: color-gray,
    )
    #primary
  ][
    #tertiary-right-header[#secondary]
  ]
}


//------------------------------------------------------------------------------
// Header (adjusted based on https://github.com/kazuyanagimoto/quarto-awesomecv-typst#readme)
//------------------------------------------------------------------------------

#let create-header-name(
  firstname: "",
  lastname: "",
) = {
  
  v(5pt)
  
    block[
      #set text(
        size: 28pt,
        style: "normal",
        font: (font-header),
      )
      #text(fill: color-gray, weight: "thin")[#firstname]
      #text(weight: "bold")[#lastname]
    ]
  
}

#let create-header-position(
  position: "",
) = {
  set block(
      above: 1.2em,
      below: 1.2em,
    )
  
  set text(
    color-accent,
    size: 11pt,
    weight: "bold",
  )
    
  smallcaps[
    #position
  ]
}

#let create-header-address(
  address: ""
) = {
  set block(
      above: 1em,
      below: 1em,
  )
  set text(
    color-lightgray,
    size: 9pt,
    style: "italic",
  )

  block[#address]
}




#let create-header-contacts(
  contacts: (),
) = {
  let separator = box(width: 2pt)
  if contacts.len() > 0 {
    let half-length = calc.ceil(contacts.len() / 2)
    block[
      #set text(
        size: 9pt,
        weight: "regular",
        style: "normal",
      )
      #set underline(stroke: color-lightgreen)
      #grid(
        columns: (1fr),
        row-gutter: 5pt,
        [
          #align(right)[
            #for contact in contacts.slice(0, half-length) [
              #box[#parse_icon_string(contact.icon) #underline[#link(contact.url)[#contact.text]]]
              #if contact != contacts.at(half-length - 1) [#separator]
            ]
          ]
        ],
        [
          #align(right)[
            #for contact in contacts.slice(half-length) [
              #box[#parse_icon_string(contact.icon) #underline[#link(contact.url)[#contact.text]]]
              #if contact != contacts.last() [#separator]
            ]
          ]
        ]
      )
    ]
  }
}



#let create-header-summary(
  summary: ""
) = {
  set block(
      above: 2em,
      below: 1em,
  )
  set text(
    color-accent,
    size: 10pt,
    //weight: "bold",
    style: "italic",
  )

  block[#summary]
}



#let create-header-info(
  firstname: "",
  lastname: "",
  position: "",
  address: "",
  contacts: (),
  summary: "",
  align-header: center
) = {
  align(align-header)[
    #create-header-name(firstname: firstname, lastname: lastname)
    #create-header-position(position: position)
    #create-header-address(address: address)
    #create-header-contacts(contacts: contacts)
    #create-header-summary(summary: summary)
  ]
}



#let create-header-image(
  profile-photo: ""
) = {
  if profile-photo.len() > 0 {
    block(
      width: 150pt,  // Adjust this value to change the size of the circular photo
      height: 150pt, // Make sure width and height are the same for a perfect circle
      stroke: none,
      radius: 50%,   // This makes the container circular
      clip: true,    // This ensures the image is clipped to the circular shape
      align(center + horizon)[
        #image(
          profile-photo,
          width: 100%,
          height: 100%,
          fit: "cover"
        )
      ]
    )
  }
}


#let create-header(
  firstname: "",
  lastname: "",
  position: "",
  address: "",
  contacts: (),
  summary: "",
  profile-photo: "",
) = {

  v(0.5mm)  // Vertical space at the top of the page
  
  if profile-photo.len() > 0 {
    grid(
      columns: (auto, 1fr),
      gutter: 10pt,
      align(horizon)[  // Changed from center + horizon to just horizon
        #create-header-image(
          profile-photo: profile-photo,
        )
      ],
      align(right)[
        #create-header-info(
          firstname: firstname,
          lastname: lastname,
          position: position,
          address: address,
          contacts: contacts,
          summary: summary,
          align-header: right
        )
      ]
    )
  } else {
    create-header-info(
      firstname: firstname,
      lastname: lastname,
      position: position,
      address: address,
      contacts: contacts,
      summary: summary, 
      align-header: center
    )
  }
  
  v(6.5mm)  // Vertical space 
}


//------------------------------------------------------------------------------
// Functions for CV Entries
//------------------------------------------------------------------------------

#let resume-item(body) = {
  set text(
    size: 10pt,
    style: "normal",
    weight: "light",
    fill: color-darknight,
  )
  set par(leading: 0.65em)
  set list(indent: 1em)
  body
}

#let resume-entry(
  title: none,
  date: "",
  location: "",
  description: "",
  top-space: 1.8em,
  below-space: 0.4em  
) = {
  block(above: top-space)[
    #justified-header(title, date)
    #secondary-justified-header(description, location)
    #v(below-space)  // Adds vertical space after second header
  ]
}



//------------------------------------------------------------------------------
// CV Template
//------------------------------------------------------------------------------

#let leftpanel_state = state("leftpanel_state", ())
#let rightpanel_state = state("rightpanel_state", ())

#let leftpanel(body) = leftpanel_state.update(it => it + (body,))
#let rightpanel(body) = rightpanel_state.update(it => it + (body,))


#let resume(
  title: "CV",
  author: (:),
  date: datetime.today().display("[month repr:long] [day], [year]"),
  profile-photo: "",
  body,
) = {
  
  set document(
    author: author.firstname + " " + author.lastname,
    title: title,
  )
  
  set text(
    font: (font-text),
    size: 9pt,
    fill: color-darkgray,
    fallback: true,
  )
  
  set page(
    paper: "a4",
    margin: (left: 15mm, right: 15mm, top: 10mm, bottom: 10mm),
    footer: [
      #set text(
        fill: gray,
        size: 8pt,
      )
      
        #smallcaps[
          //#author.firstname
          //#author.lastname
          //#sym.dot.c
          This CV is programmed using R, Quarto and Typst, code available from my github repository: https://github.com/serigra/CV-Typst-Template
        ]
      
        //#counter(page).display()
      
    ],
  )
  
  // set paragraph spacing

  set heading(
    numbering: none,
    outlined: false,
  )
  
  show heading.where(level: 1): it => [
    #set block(
      above: 1.5em,
      below: 1em,
    )
    #set text(
      size: 14pt,
      weight: "regular",
    )
    
    #align(left)[
      #text[#strong[#text(color-accent)[#it.body.text.slice(0, 3)]#text(color-darkgray)[#it.body.text.slice(3)]]]
      #box(width: 1fr, line(length: 100%, stroke: 0.5pt + color-lightgray))
    ]
  ]
  
  show heading.where(level: 2): it => {
    set text(
      color-accent-default, //color-middledarkgray,
      size: 12pt,
      weight: "thin"
    )
    it.body
  }
  
  show heading.where(level: 3): it => {
    set text(
      size: 10pt,
      weight: "regular",
      fill: color-gray,
    )
    smallcaps[#it.body]
  }
  
  // Contents
  create-header(firstname: author.firstname,
                lastname: author.lastname,
                position: author.position,
                address: author.address,
                contacts: author.contacts,
                summary: author.summary,
                profile-photo: profile-photo,)
  
    
  body
  
  
  
  grid(
   
    columns: (67%, 33%),
    inset: 3pt,
    gutter: 20pt,
    
    // Left panel --------------------------------------------------------------
    grid.cell(
    
      locate(loc => {
        for element in leftpanel_state.final(loc) {
          element
        }
      }),
      
    ),
    
    // Right panel -------------------------------------------------------------
    grid.cell(
      locate(loc => {
        set image(width: 100%)
        for element in rightpanel_state.final(loc) {
          element
        }
      }),
      //align: center + horizon
    )
  )
  
  
}