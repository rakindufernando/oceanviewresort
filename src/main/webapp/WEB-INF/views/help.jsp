<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  request.setAttribute("pageTitle", "Help - Ocean View Resort");
  String ctx = request.getContextPath();
%>
<jsp:include page="partials/header.jsp"/>
<style>


  .help-wrap{
    --bg1:#f4fbff;
    --bg2:#eef6ff;
    --card:#ffffff;
    --text:#0b2b3a;
    --muted:#3a6a93;
    --line:#cfe6ff;
    --line2:#d6ecff;

    --blue:#2aa7ff;
    --blue2:#0f86d6;
    --purple:#7c5cff;
    --teal:#00b3a4;
    --orange:#ff9f43;

    padding:18px;
    color:var(--text);
  }


  .help-wrap{
    background:linear-gradient(180deg, var(--bg1), var(--bg2));
    border:1px solid var(--line);
    border-radius:16px;
    box-shadow:0 14px 34px rgba(15,134,214,0.10);
  }


  .help-wrap .help-hero{
    display:flex;
    justify-content:space-between;
    gap:14px;
    flex-wrap:wrap;
    align-items:flex-end;
    padding:14px;
    border:1px solid var(--line);
    background:linear-gradient(90deg, rgba(42,167,255,0.10), rgba(124,92,255,0.08));
    border-radius:14px;
  }

  .help-wrap h2{
    font-size:22px;
    letter-spacing:0.2px;
  }

  .help-wrap .small{
    color:var(--muted);
  }

  .help-wrap .help-search{
    min-width:280px;
    max-width:560px;
    flex:1;
  }

  .help-wrap .help-search input{
    width:100%;
    padding:12px 12px;
    border-radius:12px;
    border:1px solid var(--line);
    background:#ffffff;
    outline:none;
    transition:box-shadow 0.2s ease, border-color 0.2s ease, transform 0.2s ease;
  }

  .help-wrap .help-search input:focus{
    border-color:rgba(42,167,255,0.7);
    box-shadow:0 0 0 4px rgba(42,167,255,0.18);
    transform:translateY(-1px);
  }

  .help-wrap .help-actions{
    display:flex;
    gap:10px;
    margin-top:10px;
    flex-wrap:wrap;
  }


  .help-wrap .help-links{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    margin:14px 0 10px 0;
  }


  .help-wrap .btn2{
    border:1px solid var(--line);
    background:#ffffff;
    color:var(--text);
    border-radius:999px;
    padding:10px 14px;
    font-weight:700;
    transition:transform 0.15s ease, box-shadow 0.15s ease, border-color 0.15s ease;
  }

  .help-wrap .btn2:hover{
    transform:translateY(-1px);
    border-color:rgba(42,167,255,0.8);
    box-shadow:0 10px 22px rgba(15,134,214,0.12);
  }

  .help-wrap .btn2:active{
    transform:translateY(0px);
    box-shadow:none;
  }

  .help-wrap .help-note{
    padding:12px 12px;
    border:1px solid var(--line);
    background:linear-gradient(90deg, rgba(0,179,164,0.10), rgba(42,167,255,0.10));
    border-radius:14px;
    margin-bottom:12px;
    font-size:13px;
  }


  .help-wrap .faq{
    border:1px solid var(--line);
    border-radius:16px;
    background:rgba(255,255,255,0.92);
    margin:12px 0;
    overflow:hidden;
    box-shadow:0 10px 22px rgba(11,43,58,0.06);
  }

  .help-wrap .faq summary{
    cursor:pointer;
    list-style:none;
    padding:12px 14px;
    font-weight:800;
    color:var(--text);
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:10px;
    user-select:none;
    background:linear-gradient(90deg, rgba(42,167,255,0.12), rgba(255,159,67,0.08));
    border-bottom:1px solid rgba(207,230,255,0.7);
  }

  .help-wrap .faq summary::-webkit-details-marker{
    display:none;
  }

  .help-wrap .faq summary::after{
    content:"▼";
    font-size:12px;
    color:var(--muted);
    transition:transform 0.2s ease;
  }

  .help-wrap .faq[open] summary::after{
    transform:rotate(180deg);
  }

  .help-wrap .faq[open]{
    border-color:rgba(42,167,255,0.65);
    box-shadow:0 16px 34px rgba(15,134,214,0.10);
  }


  .help-wrap .help-grid{
    display:flex;
    gap:14px;
    flex-wrap:wrap;
    margin-top:10px;
    align-items:flex-start;
    padding:12px 14px 16px 14px;
  }

  .help-wrap .help-grid > div:first-child{
    flex:1 1 420px;
    min-width:320px;
  }

  .help-wrap .help-grid > div:last-child{
    flex:0 0 620px;
    max-width:620px;
  }


  .help-wrap .help-steps{
    margin:8px 0 0 18px;
  }

  .help-wrap .help-steps li{
    margin:7px 0;
    font-size:13px;
    line-height:1.5;
  }

  .help-wrap .help-mini{
    margin-top:12px;
    padding:12px;
    border-radius:14px;
    border:1px solid var(--line2);
    background:linear-gradient(180deg, rgba(247,251,255,1), rgba(255,255,255,1));
    font-size:13px;
  }

  .help-wrap .help-mini b{
    display:inline-block;
    padding:6px 10px;
    border-radius:999px;
    background:rgba(124,92,255,0.10);
    border:1px solid rgba(124,92,255,0.22);
  }

  .help-wrap .help-mini ul{
    margin:10px 0 0 18px;
  }


  .help-wrap .help-shot{
    width:100% !important;
    max-width:620px !important;
    border-radius:16px;
    padding:10px;
    background:linear-gradient(180deg, rgba(255,255,255,1), rgba(247,251,255,1));
    border:1px solid rgba(207,230,255,0.85);
    box-shadow:0 16px 34px rgba(11,43,58,0.10);
    overflow:hidden;
    margin:0 auto;
    box-sizing:border-box;
  }

  .help-wrap .help-shot-title{
    font-size:12px;
    color:var(--muted);
    margin-bottom:8px;
    display:flex;
    align-items:center;
    justify-content:space-between;
  }

  .help-wrap .help-shot-title::after{
    content:"● ● ●";
    letter-spacing:3px;
    font-size:10px;
    color:rgba(58,106,147,0.65);
  }

  .help-wrap .help-shot-caption{
    margin-top:8px;
    font-size:12px;
    color:var(--muted);
  }


  .help-wrap img.help-img{
    display:block !important;
    width:100% !important;
    max-width:620px !important;
    height:auto !important;

    max-height:290px !important;
    object-fit:contain !important;

    border-radius:14px;
    border:1px solid rgba(207,230,255,0.95);
    background:#ffffff;
    box-shadow:0 10px 22px rgba(15,134,214,0.10);
    margin:0 auto !important;
  }


  .help-wrap .chip{
    display:inline-block;
    padding:6px 10px;
    border-radius:999px;
    font-size:12px;
    font-weight:800;
    border:1px solid var(--line);
    background:#fff;
    color:var(--text);
  }

  .help-wrap .chip.blue{background:rgba(42,167,255,0.12); border-color:rgba(42,167,255,0.25);}
  .help-wrap .chip.purple{background:rgba(124,92,255,0.12); border-color:rgba(124,92,255,0.25);}
  .help-wrap .chip.teal{background:rgba(0,179,164,0.12); border-color:rgba(0,179,164,0.25);}
  .help-wrap .chip.orange{background:rgba(255,159,67,0.14); border-color:rgba(255,159,67,0.28);}


  .help-wrap .tip-demo{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    width:16px;
    height:16px;
    border-radius:50%;
    border:1px solid var(--line);
    background:#ffffff;
    color:var(--blue2);
    font-size:12px;
    font-weight:900;
    line-height:1;
  }

  .help-wrap .tip{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    width:16px;
    height:16px;
    margin-left:6px;
    border-radius:50%;
    border:1px solid var(--line);
    background:#ffffff;
    color:var(--blue2);
    font-size:12px;
    font-weight:900;
    cursor:help;
    position:relative;
    top:-1px;
    transition:transform 0.15s ease, box-shadow 0.15s ease;
  }

  .help-wrap .tip:hover{
    transform:translateY(-1px);
    box-shadow:0 8px 16px rgba(15,134,214,0.12);
  }

  .help-wrap .tip:focus{
    outline:2px solid rgba(42,167,255,0.55);
    outline-offset:2px;
  }

  .help-wrap .tip:hover::after,
  .help-wrap .tip:focus::after{
    content: attr(data-tip);
    position:absolute;
    left:0;
    top:22px;
    min-width:220px;
    max-width:320px;
    background:linear-gradient(180deg, #0b2b3a, #0d3a52);
    color:#ffffff;
    padding:10px 12px;
    border-radius:12px;
    font-size:12px;
    line-height:1.35;
    z-index:9999;
    box-shadow:0 10px 22px rgba(0,0,0,0.18);
  }

  .help-wrap .tip:hover::before,
  .help-wrap .tip:focus::before{
    content:"";
    position:absolute;
    left:8px;
    top:18px;
    width:0;
    height:0;
    border-left:6px solid transparent;
    border-right:6px solid transparent;
    border-bottom:6px solid #0b2b3a;
  }


  @media (max-width: 1100px){
    .help-wrap .help-grid > div:last-child{
      flex:0 0 560px;
      max-width:560px;
    }
    .help-wrap img.help-img{
      max-width:560px !important;
      max-height:270px !important;
    }
  }

  @media (max-width: 900px){
    .help-wrap .help-grid > div:last-child{
      flex:1 1 100%;
      max-width:100%;
    }
    .help-wrap .help-shot{
      max-width:100% !important;
    }
    .help-wrap img.help-img{
      max-width:100% !important;
      max-height:240px !important;
    }
  }

  @media (max-width: 600px){
    .help-wrap{
      padding:12px;
    }
    .help-wrap .help-hero{
      padding:12px;
    }
    .help-wrap .btn2{
      width:100%;
      justify-content:center;
      text-align:center;
    }
  }
</style>

<div class="card help-wrap">

  <div class="help-hero">
    <div>
      <h2 style="margin:0;">Help / FAQ</h2>
      <p class="small" style="margin:6px 0 0 0;">
        Quick guide for new staff members. Use the search to find steps fast.
      </p>
    </div>

    <div class="help-search">
      <input id="helpSearch" type="text" placeholder="Search help... (ex: bill, cancel, dates)" />
      <div class="help-actions">
        <button class="btn2" type="button" onclick="expandAllFaq(true)">Expand All</button>
        <button class="btn2" type="button" onclick="expandAllFaq(false)">Collapse</button>
      </div>
    </div>
  </div>

  <div class="help-links">
    <a class="btn2" href="#faq-reservation">How to add reservation</a>
    <a class="btn2" href="#faq-bill">How to print bill</a>
    <a class="btn2" href="#faq-cancel">How to cancel booking</a>
    <a class="btn2" href="#faq-guests">Guest management</a>
    <a class="btn2" href="#faq-res-crud">Reservations edit and update</a>
    <a class="btn2" href="#faq-payment">Add payment and check balance</a>
    <a class="btn2" href="#faq-early-checkout">Early checkout</a>
    <a class="btn2" href="#faq-availability">Check room availability</a>
  </div>




  <details class="faq" id="faq-reservation" open>
    <summary>How to add a reservation</summary>

    <div class="help-grid">
      <div>
        <ol class="help-steps">
          <li>Go to <b>Reservations</b> page.</li>
          <li>Click <b>Add New Reservation</b>.</li>
          <li><b>Step 1: Find Guest</b> → type Mobile or NIC/Passport and click <b>Search</b>.</li>
          <li>If guest is found, the Guest ID will fill automatically (readonly).</li>
          <li><b>Step 2: Reservation Details</b> → select <b>Room Type</b>.</li>
          <li>Select <b>Check-In</b> and <b>Check-Out</b> dates.</li>
          <li>System will show availability (Available rooms / Fully booked).</li>
          <li>Click <b>Save Reservation</b>.</li>
        </ol>

        <div class="help-mini">
          <b>Common mistakes</b>
          <ul>
            <li>Check-out date earlier than check-in date.</li>
            <li>Room type not selected before choosing dates.</li>
            <li>Guest not added (If guest not found, add guest from Guests page first).</li>
          </ul>
        </div>
      </div>

      <div class="help-shot" aria-label="Reservation form screenshot">
        <div class="help-shot-title">Sample Screen</div>

        <img class="help-img"
             src="<%=ctx%>/assets/help/reservation.png"
             alt="Add New Reservation screen">

        <div class="small help-shot-caption">
          Add New Reservation page
        </div>
      </div>
    </div>
  </details>


  <details class="faq" id="faq-bill">
    <summary>How to print bill (invoice)</summary>

    <div class="help-grid">
      <div>
        <ol class="help-steps">
          <li>Go to <b>Billing</b> page.</li>
          <li>Type the <b>Reservation No</b> (Example: OV-2026-00001) and click <b>Search</b>.</li>
          <li>Invoice details will appear (nights, rate per night, total, paid, balance).</li>
          <li>Click <b>Print Bill</b>.</li>
          <li>In print preview, choose printer or “Save as PDF” (optional).</li>
        </ol>

        <div class="help-mini">
          <b>If bill is empty</b>
          <ul>
            <li>Check the reservation number is correct.</li>
            <li>Reservation might be cancelled (status check in reservations list).</li>
          </ul>
        </div>
      </div>

      <div class="help-shot" aria-label="Billing screenshot">
        <div class="help-shot-title">Sample Screen</div>

        <img class="help-img"
             src="<%=ctx%>/assets/help/billing.png"
             alt="Billing and Payments screen">

        <div class="small help-shot-caption">
          Billing and Payments page
        </div>
      </div>
    </div>
  </details>


  <details class="faq" id="faq-cancel">
    <summary>How to cancel a booking (reservation)</summary>

    <div class="help-grid">
      <div>
        <ol class="help-steps">
          <li>Go to <b>Reservations</b> page.</li>
          <li>Find the reservation using search (Reservation No / Guest Name).</li>
          <li>Click <b>Cancel</b> in the Actions column.</li>
          <li>Confirm the popup message.</li>
          <li>Status will update as cancelled and the room becomes available again.</li>
        </ol>

        <div class="help-mini">
          <b>Note</b>
          <ul>
            <li>Cancel is different from deleting (Admin has delete options).</li>
            <li>Cancelled reservations should not be used for billing.</li>
          </ul>
        </div>
      </div>

      <div class="help-shot" aria-label="Reservation list screenshot">
        <div class="help-shot-title">Sample Screen</div>

        <img class="help-img"
             src="<%=ctx%>/assets/help/reservation_list.png"
             alt="Reservation Management screen">

        <div class="small help-shot-caption">
          Reservation Management page
        </div>
      </div>
    </div>
  </details>


  <details class="faq" id="faq-guests">
    <summary>Guest management</summary>

    <div class="help-grid">
      <div>
        <ol class="help-steps">
          <li>Open Guest Management from the side menu</li>
          <li>To add a guest click Add New Guest</li>
          <li>Fill the form and save</li>
          <li>Mobile number and NIC Passport must be unique</li>
          <li>To edit search the guest then click Edit and update</li>
          <li>To delete use Delete if your system has soft delete it will hide the record</li>
        </ol>

        <div class="help-mini">
          <b>Useful tips</b>
          <ul>
            <li>Always check the mobile number before adding a new guest</li>
            <li>If a guest exists do not create a new duplicate record</li>
            <li>Use correct name format to avoid report issues</li>
          </ul>
        </div>
      </div>

      <div class="help-shot">
        <div class="help-shot-title">Sample Screen</div>

        <img class="help-img"
             src="<%=ctx%>/assets/help/guests.png"
             alt="Guest Management screen">

        <div class="small help-shot-caption">Guest Management page</div>
      </div>
    </div>
  </details>


  <details class="faq" id="faq-res-crud">
    <summary>Reservations edit and update</summary>

    <div class="help-grid">
      <div>
        <ol class="help-steps">
          <li>Open Reservation Management</li>
          <li>Search using Reservation No or Guest Name</li>
          <li>To update click Edit then change dates or room type and save</li>
          <li>To cancel click Cancel and confirm the popup</li>
          <li>To print bill click Bill to go to billing for that reservation</li>
        </ol>

        <div class="help-mini">
          <b>Common mistakes</b>
          <ul>
            <li>Changing dates without checking availability</li>
            <li>Editing to same dates that overlap with fully booked periods</li>
            <li>Trying to bill a cancelled reservation</li>
          </ul>
        </div>
      </div>

      <div class="help-shot">
        <div class="help-shot-title">Sample Screen</div>
        <img class="help-img"
             src="<%=ctx%>/assets/help/reservation_list.png"
             alt="Reservation Management screen">
        <div class="small help-shot-caption">Reservation Management page</div>
      </div>
    </div>
  </details>


  <details class="faq" id="faq-payment">
    <summary>Add payment and check balance</summary>

    <div class="help-grid">
      <div>
        <ol class="help-steps">
          <li>Open Billing and Payments</li>
          <li>Enter Reservation No and click Search</li>
          <li>Check the calculated total amount and paid amount</li>
          <li>Enter payment amount and click Add Payment or Save Payment</li>
          <li>Check the balance field to confirm remaining amount</li>
          <li>If balance is zero you can print the final bill</li>
        </ol>

        <div class="help-mini">
          <b>Payment checks</b>
          <ul>
            <li>Do not enter negative values</li>
            <li>Do not enter more than remaining balance unless your system allows advance payments</li>
            <li>Always confirm balance after saving payment</li>
          </ul>
        </div>
      </div>

      <div class="help-shot">
        <div class="help-shot-title">Sample Screen</div>
        <img class="help-img"
             src="<%=ctx%>/assets/help/billing.png"
             alt="Billing and Payments screen">
        <div class="small help-shot-caption">Billing and Payments page</div>
      </div>
    </div>
  </details>


  <details class="faq" id="faq-early-checkout">
    <summary>Early checkout</summary>

    <div class="help-grid">
      <div>
        <ol class="help-steps">
          <li>Open Early Checkout from the side menu</li>
          <li>Search the reservation using Reservation No</li>
          <li>Select the actual checkout date</li>
          <li>Click Update Checkout or Confirm</li>
          <li>System will recalculate nights and billing total</li>
          <li>Go to Billing and Payments and confirm the balance</li>
        </ol>

        <div class="help-mini">
          <b>Note</b>
          <ul>
            <li>Early checkout should free rooms earlier for new bookings</li>
            <li>Always print updated bill after early checkout</li>
          </ul>
        </div>
      </div>

      <div class="help-shot">
        <div class="help-shot-title">Sample Screen</div>

        <img class="help-img"
             src="<%=ctx%>/assets/help/early_checkout.png"
             alt="Early Checkout screen">

        <div class="small help-shot-caption">Early Checkout page</div>
      </div>
    </div>
  </details>


  <details class="faq" id="faq-availability">
    <summary>Check room availability</summary>

    <div class="help-grid">
      <div>
        <ol class="help-steps">
          <li>Open Add New Reservation</li>
          <li>Select Room Type first</li>
          <li>Select Check In and Check Out dates</li>
          <li>System will show availability message</li>
          <li>If it says FULLY BOOKED select different dates or another room type</li>
        </ol>

        <div class="help-mini">
          <b>Extra checks</b>
          <ul>
            <li>Availability is based on overlapping dates</li>
            <li>Cancelled reservations should not block availability</li>
            <li>If you updated checkout via early checkout availability should increase</li>
          </ul>
        </div>
      </div>

      <div class="help-shot">
        <div class="help-shot-title">Sample Screen</div>
        <img class="help-img"
             src="<%=ctx%>/assets/help/reservation.png"
             alt="Add New Reservation screen">
        <div class="small help-shot-caption">Add New Reservation page</div>
      </div>
    </div>
  </details>

  <hr>

  <div class="help-mini">
    <b>Other quick notes</b>
    <ul style="margin:8px 0 0 18px;">
      <li><b>Login</b>: If username/password not working → ask Admin to reset password.</li>
      <li><b>Guests</b>: Mobile number and NIC/Passport must be unique.</li>
      <li><b>Reports</b>: Manager/Admin can use date range and generate reports.</li>
    </ul>
  </div>

</div>

<script>
  function expandAllFaq(open){
    var items = document.querySelectorAll(".faq");
    items.forEach(function(d){ d.open = open; });
  }


  (function(){
    var box = document.getElementById("helpSearch");
    if(!box) return;

    box.addEventListener("input", function(){
      var q = (box.value || "").toLowerCase().trim();
      var items = document.querySelectorAll(".faq");

      items.forEach(function(d){
        var text = (d.innerText || "").toLowerCase();
        if(!q){
          d.style.display = "";
          return;
        }
        var match = text.indexOf(q) !== -1;
        d.style.display = match ? "" : "none";
        if(match) d.open = true;
      });
    });
  })();
</script>

<jsp:include page="partials/footer.jsp"/>