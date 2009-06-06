// Jam Templates -- a jQuery Plugin
// Copyright (c) 2007,2008 Tiger Ops 
// http://tigerops.psytower.info
//
// Jam is a "weaving" template system that
// operate fully on the front-end, thus off-loading
// some of the back-end work load while also
// providing 100% SOC (Seperation of Concern).
//
// Example:
//
//   data = {
//     hello: "Hello, World!"
//   }
//
//   $.jam(data)
//
// Jam templates are especially useful when
// filled via AJAX with JSON data. For this reason
// a shortcut is provided.
//
//   $.jam_ajax('http://somewhere/data.json')
//

// FOR DEBUGGING
/*
function inspect(obj) {
  var txt = "";
  for(var prop in obj) {
    txt += prop + ": " + obj[prop] + "\n";
  }
  alert(txt);
};
*/

jQuery.jam_ajax = function(url) {
  result = url.match(/[.]xml$/);
  if (result != null) {
    jQuery.getXML(url, jQuery.cherry_xml);
  } else {
    jQuery.getJSON(url, jQuery.cherry);
  }
};

jQuery.getXML = function(url, callback) {
  jQuery.ajax({
    dataType: "xml",
    url: url,
    success: callback
  });
};

// Interpolate XML by converting to JSON.
// This only work is xml2json.js is loaded.

jQuery.jam_xml = function(xml) {
  var json = xml2json(xml,'  ');
  //var data = json.parseJSON();
  var data = eval('(' + json + ')');  // SECURE ME!
  jQuery.cherry(data);
};

// Interpolate JSON data.

jQuery.jam = function(data) {
  jQuery('body').interpolate(data);
};

// Interpolate data into template nodes.

jQuery.fn.interpolate = function(data) {
  if(!data) {
    this.remove();
  }
  else if (data instanceof Array) {
    this.interpolate_array(data);
  }
  else if(data instanceof Object) {
    this.interpolate_object(data);
  }
  else {
    this.interpolate_value(data);
  };
  return this;
};

// Interpolate object mapping.

jQuery.fn.interpolate_object = function(data) {
  var qry;
  var attr;
  var tag;
  var result;
  var match;

  for (var id in data) {
    attr = false;
    tag  = false;
    qry  = id;

    result = qry.match(/^<(.*?)>$/);
    if (result != null) {
      tag = true;
      qry = result[1];
    };

    result = qry.match(/^((.*?)\/)?([@](.*?))$/);
    if (result != null) {
      if (result[2] == undefined) { result[2] = null };
      attr = result[4];
      qry  = result[2] //+ '[@' + attr + ']';
    }
    else {
      attr = false;
    };

    if (attr == false) {
      if (tag == false) { qry = '#' + qry; }
      // probably change to use 'ref' attribute instead of 'id'
      match = this.find(qry)
      if (match.size() > 0) {
        match.interpolate(data[id]);
      }
    }
    else {
      //qry = qry + '[@' + attr + ']';
      //this.find(qry).attr(attr,data[id]);
      if (qry != null) {
        if (tag == false) { qry = '#' + qry; }
        this.find(qry).attr(attr,data[id]);
      } else {
        this.attr(attr,data[id]);
      }
    };
  };
};

// Interpolate attribute.
//
// TODO

// Interpolate array sequence.

jQuery.fn.interpolate_array = function(data) {
  var temp = this.clone();
  this.empty();
  for (var i in data) {
    var newNode = temp.clone();
    newNode.interpolate(data[i]);
    this.append(newNode); //.children());
  };
};

// Interpolate value.
//
// This has some special HTML features.
//
// TODO Should we have two modes --one with and one
// without the extra HTML features?

jQuery.fn.interpolate_value = function(data) {
  //var all_special = new Array;

  // text inputs
  //var special = this.find('input[@type=text]');
  //special.val(data.toString());
  //all_special.concat(special);
  // textarea
  // TODO

  //this.not(special).empty();
  //this.not(special).append(data.toString());
//alert(data);
  this.empty();
  this.append(data.toString());
};



/*
// Interpolate list.

function interpolate_list(node, data) {
  temp = node.copy(true)
  node.empty!
  for (var d in data) {
    nc = temp.copy(true);
    interpolate_children( nc, d )
    for (var c in nc.children) {
      node.add(c);
    };
  };
};
*/

