"use strict";!function(){var a=JSON.parse(document.body.getAttribute("data-translations"));function i(t,e){return t.toFixed(e).replace(/\./,a["."])}function o(t,e){e--;for(var n=t;10<=n&&0<e;n/=10)e--;return i(t,e)}function r(t){return function(t,e,n){var r=0;if(void 0===n)return"- ";for(;e<n&&r<t.length-1;)n/=e,r++;return(n=o(n,3))+" "+t[r]}(["","K","M","G","T"],1024,t)}String.prototype.sprintf=function(){var t=0,e=arguments;return this.replace(/%s/g,function(){return e[t++]})};var s={id:function(t){return t},decimal:function(t){return i(t,2)},percent:function(t){return a["%s used"].sprintf(o(100*t,3)+"%")},memory:function(t){var e=1-t.available/t.total;return s.percent(e)},time:function(t){var e=Math.round(t/60),n=Math.floor(e/1440),r=Math.floor(e%1440/60);e=Math.floor(e%60);var i="";return 1===n?i+=a["1 day"]+", ":1<n&&(i+=a["%s days"].sprintf(n)+", "),i+=r+":",e<10&&(i+="0"),i+=e},packetsDiff:function(t,e,n){if(0<n)return r=(t-e)/n,a["%s packets/s"].sprintf(i(r,0));var r},bytesDiff:function(t,e,n){if(0<n)return r(8*((t-e)/n))+"bps"},bytes:function(t){return r(t)+"B"},neighbour:function(t){if(!t)return"";for(var e in c){var n=c[e].lookup_neigh(t);if(n)return"via "+n.get_hostname()+" ("+e+")"}return"via "+t+" (unknown iface)"}};function f(e,t){return t.split("/").forEach(function(t){e=e&&e[t]}),e}function l(t,n){var e=new EventSource(t),r={};e.onmessage=function(t){var e=JSON.parse(t.data);n(e,r),r=e},e.onerror=function(){e.close(),window.setTimeout(function(){l(t,n)},3e3)}}var C,w=document.body.getAttribute("data-node-address");try{C=JSON.parse(document.body.getAttribute("data-node-location"))}catch(t){}function t(t){var e=document.getElementById("mesh-vpn");if(t){e.style.display="";for(var i=document.getElementById("mesh-vpn-peers");i.lastChild;)i.removeChild(i.lastChild);var n=function e(n,r){return Object.keys(r.peers||{}).forEach(function(t){n.push([t,r.peers[t]])}),Object.keys(r.groups||{}).forEach(function(t){e(n,r.groups[t])}),n}([],t);n.sort(),n.forEach(function(t){var e=document.createElement("tr"),n=document.createElement("th");n.textContent=t[0],e.appendChild(n);var r=document.createElement("td");t[1]?r.textContent=a.connected+" ("+s.time(t[1].established)+")":r.textContent=a["not connected"],e.appendChild(r),i.appendChild(e)})}else e.style.display="none"}var e=document.querySelectorAll("[data-statistics]");l("/cgi-bin/dyn/statistics",function(o,c){var u=o.uptime-c.uptime;e.forEach(function(t){var e=t.getAttribute("data-statistics"),n=t.getAttribute("data-format"),r=f(c,e),i=f(o,e);try{var a=s[n](i,r,u);void 0!==a&&(t.textContent=a)}catch(t){console.error(t)}});try{t(o.mesh_vpn)}catch(t){console.error(t)}});var c={};function E(a){var o=document.createElement("canvas"),c=o.getContext("2d"),u=null;return{canvas:o,highlight:!1,resize:function(t,e){try{c.getImageData(0,0,t,e)}catch(t){}o.width=t,o.height=e},draw:function(t,e){var n,r,i=e(u);c.clearRect(t,0,5,o.height),i&&(n=t,r=i,c.beginPath(),c.fillStyle=a,c.arc(n,r,1.2,0,2*Math.PI,!1),c.closePath(),c.fill())},set:function(t){u=t}}}function h(){var u=-100,s=0,n=0,r=[],f=document.createElement("canvas");f.className="signalgraph",f.height=200;var l=f.getContext("2d");function t(){f.width=f.clientWidth,r.forEach(function(t){t.resize(f.width,f.height)})}function i(){if(0!==f.clientWidth){f.width!==f.clientWidth&&t(),l.clearRect(0,0,f.width,f.height);var e=!1;r.forEach(function(t){t.highlight&&(e=!0)}),l.save(),r.forEach(function(t){e&&(l.globalAlpha=.2),t.highlight&&(l.globalAlpha=1),t.draw(n,function(t){return e=t,n=u,r=s,i=f.height,(1-(e-n)/(r-n))*i;var e,n,r,i}),l.drawImage(t.canvas,0,0)}),l.restore(),l.save(),l.beginPath(),l.strokeStyle="rgba(255, 180, 0, 0.15)",l.lineWidth=5,l.moveTo(n+2.5,0),l.lineTo(n+2.5,f.height),l.stroke(),function(){var t,e,n,r,i=Math.floor(f.height/40);l.save(),l.lineWidth=.5,l.strokeStyle="rgba(0, 0, 0, 0.25)",l.fillStyle="rgba(0, 0, 0, 0.5)",l.textAlign="end",l.textBaseline="bottom",l.beginPath();for(var a=0;a<i;a++){var o=f.height-40*a;l.moveTo(0,o-.5),l.lineTo(f.width,o-.5);var c=Math.round((t=o,e=u,n=s,r=f.height,(e*t+n*(r-t))/r))+" dBm";l.save(),l.strokeStyle="rgba(255, 255, 255, 0.9)",l.lineWidth=4,l.miterLimit=2,l.strokeText(c,f.width-5,o-2.5),l.fillText(c,f.width-5,o-2.5),l.restore()}l.stroke(),l.strokeStyle="rgba(0, 0, 0, 0.83)",l.lineWidth=1.5,l.strokeRect(.5,.5,f.width-1,f.height-1),l.restore()}()}}t(),window.addEventListener("resize",i);var a=0;return window.requestAnimationFrame(function t(e){40<e-a&&(i(),n=(n+1)%f.width,a=e),window.requestAnimationFrame(t)}),{el:f,addSignal:function(t){r.push(t),t.resize(f.width,f.height)},removeSignal:function(t){r.splice(r.indexOf(t),1)}}}function d(t,e,n,r){var i=t.table.firstElementChild,a=t.table.insertRow(),o=a.insertCell();if(t.wireless){var c=document.createElement("span");c.textContent="⬤ ",c.style.color=n,o.appendChild(c)}var h=document.createElement("span");h.textContent=e,o.appendChild(h);var u,d,s,f,l,v={};function g(t){var e=t.getAttribute("data-key");if(e){var n=t.getAttribute("data-suffix")||"",r=a.insertCell();r.textContent="-",v[e]={td:r,suffix:n}}}for(var m=0;m<i.children.length;m++)g(i.children[m]);function p(){l&&window.clearTimeout(l),l=window.setTimeout(function(){f&&t.signalgraph.removeSignal(f),a.parentNode.removeChild(a),r()},6e4)}function b(t){var e=function(t){"::"==t.slice(0,2)&&(t="0"+t),"::"==t.slice(-2)&&(t+="0");var e=t.split(":"),n=e.length,r=[];return e.forEach(function(t,e){if(""===t)for(;n++<=8;)r.push(0);else{if(!/^[a-f0-9]{1,4}$/i.test(t))return;r.push(parseInt(t,16))}}),r}(t);if(e){var n="";return e.forEach(function(t){n+=("0000000000000000"+t.toString(2)).slice(-16)}),n}}function y(t){var r=b(w);if(t&&t[0]){(t=t.map(function(t){var e=b(t);if(!e)return[-1];var n=0;return r&&(n=function(t,e){var n;for(n=0;n<t.length&&n<e.length&&t[n]===e[n];n++);return n}(r,e)),[n,e,t]})).sort(function(t,e){return t[0]<e[0]?1:t[0]>e[0]?-1:t[1]<e[1]?-1:t[1]>e[1]?1:0});var e=t[0][2];return e&&!/^fe80:/i.test(e)?e:void 0}}return t.wireless&&((u=a.insertCell()).textContent="-",(d=a.insertCell()).textContent="-",(s=a.insertCell()).textContent="-",f=E(n),t.signalgraph.addSignal(f)),a.onmouseenter=function(){a.classList.add("highlight"),f&&(f.highlight=!0)},a.onmouseleave=function(){a.classList.remove("highlight"),f&&(f.highlight=!1)},p(),{get_hostname:function(){return h.textContent},update_nodeinfo:function(t){var e,n,r,i,a,o,c,u,s=y(t.network.addresses);if(s){if("span"===h.nodeName.toLowerCase()){var f=h;h=document.createElement("a"),f.parentNode.replaceChild(h,f)}h.href="http://["+s+"]/"}if(h.textContent=t.hostname,C&&t.location){var l=(e=C.latitude,n=C.longitude,r=t.location.latitude,i=t.location.longitude,a=Math.PI/180,o=(r*=a)-(e*=a),c=(i*=a)-(n*=a),u=Math.sin(o/2)*Math.sin(o/2)+Math.sin(c/2)*Math.sin(c/2)*Math.cos(e)*Math.cos(r),2*Math.asin(Math.sqrt(u))*6372.8);d.textContent=Math.round(1e3*l)+" m"}p()},update_mesh:function(n){Object.keys(v).forEach(function(t){var e=v[t];e.td.textContent=n[t]+e.suffix}),p()},update_wifi:function(t){u.textContent=t.signal,s.textContent=Math.round(t.inactive/1e3)+" s",a.classList.toggle("inactive",200<t.inactive),f.set(200<t.inactive?null:t.signal),p()}}}function u(t,e,n){var r,a={};n&&(r=h(),t.appendChild(r.el));var i={table:t.firstElementChild,signalgraph:r,ifname:e,wireless:n},o=!1,c={},u=[];function s(){if(!o){o=!0;var t=new EventSource("/cgi-bin/dyn/neighbours-nodeinfo?"+encodeURIComponent(e));t.addEventListener("neighbour",function(t){try{var n=JSON.parse(t.data);(r=[],i=n.network.mesh,Object.keys(i).forEach(function(t){var e=i[t].interfaces;Object.keys(e).forEach(function(t){e[t].forEach(function(t){r.push(t)})})}),r).forEach(function(t){var e=a[t];if(e){delete c[t];try{e.update_nodeinfo(n)}catch(t){console.error(t)}}})}catch(t){console.error(t)}var r,i},!1),t.onerror=function(){t.close(),o=!1,Object.keys(c).forEach(function(t){0<c[t]&&(c[t]--,s())})}}}function f(t){var e=a[t];return e||(c[t]=3,e=a[t]=d(i,t,(u[0]||(u=["#396AB1","#DA7C30","#3E9651","#CC2529","#535154","#6B4C9A","#922428","#948B3D"]),u.shift()),function(){delete c[t],delete a[t]}),s()),e}return n&&l("/cgi-bin/dyn/stations?"+encodeURIComponent(e),function(n){Object.keys(n).forEach(function(t){var e=n[t];f(t).update_wifi(e)})}),{get_neigh:f,lookup_neigh:function(t){return a[t]}}}document.querySelectorAll("[data-interface]").forEach(function(t){var e=t.getAttribute("data-interface"),n=(t.getAttribute("data-interface-address"),!!t.getAttribute("data-interface-wireless"));c[e]=u(t,e,n)});var n=document.body.getAttribute("data-mesh-provider");n&&l(n,function(r){Object.keys(r).forEach(function(t){var e=r[t],n=c[e.ifname];n&&n.get_neigh(t).update_mesh(e)})})}();