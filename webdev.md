# webdev cheat sheet

- HTML/JS/CSS jargon. Source [here](http://xahlee.info/js/javascript_DOM_confusing_terminology.html).
  - In HTML, an **element** is a `<>..</>` pair. For example "p element" (paragraph element) is `<p>..</p>`.
  - HTML elements have **attributes** such as `id="..."`, where *id* name of attributre and *"..."* value of attribute.
  - When HTML is parsed by browser into DOM, HTML element is called a **node** (or also **object**). HTML element attributes become **properties** of the node.
    - Here *node* (or *object*) are entities in DOM context. 
  - Notice that DOM object can have any properties, not necessarily one-to-one map with attributes of HTML element. JS usually adds properties to nodes.
  - In JS, an **object** is a set of key/value pairs. It is also a datatype, i.e. `typeof()` can return "object".
  - **HTML element becomes node in DOM and object in JS**.
  - In JS, **property** is each key/value pair in an JS object.
    - Two types of properties: **data properties** and **accessor properties** (getters/setters).
  - In DOM, **property** is an instance variable and it corresponds to attribute of HTML. For example, HTML atrtibute named "id" becomes property named "id" in DOM.
  - JS can also have **attributes**: these are special information of a property. Concretely, a JS object has properties and each property has attributes such as "writeable", "enumerable" etc.
  - In JS, **method** is a property whose value is a function.
  - **g** element is used to group SVG shapes together. Once grouped you can transform the whole group of shapes. [Source](http://tutorials.jenkov.com/svg/g-element.html), [another](https://stackoverflow.com/questions/17057809/d3-js-what-is-g-in-appendg-d3-js-code)



## JS/d3
 - `d3.selection.nodes()` / `d3.selection.node()`: Returns all/first non-null element in selection.