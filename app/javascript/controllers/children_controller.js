import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="children"
export default class extends Controller {
  static targets =["button", "delete"]
  static values = {
    html: String,
    id: Number,
  }

  addChild(event) {
    event.preventDefault()
    const children = this.element.querySelectorAll('.user_children_birthday')
    const numberOfChildren = children.length
    const nextChild = numberOfChildren + 1
    this.buttonTarget.insertAdjacentHTML('beforebegin', this.inputHtml(nextChild))
  }

  deleteChild(event) {
    event.preventDefault()
    const csrf = document.querySelector('meta[name="csrf-token"]').content
    console.log(event.target.dataset.id)
    fetch(`/children/${event.target.dataset.id}`, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": csrf
      }
    }).then((response) => {

      if (response.ok) {
        event.target.previousElementSibling.remove()
        event.target.remove()
      }
    })
  }

  inputHtml(childNumber) {
    return `
    <div class="mb-3 date required user_children_birthday"><label class="form-label date required" for="user_children_attributes_${childNumber}_birthday_1i">child's birthday <abbr title="required">*</abbr></label><div class="d-flex flex-row justify-content-between align-items-center"><select id="user_children_attributes_${childNumber}_birthday_1i" name="user[children_attributes][${childNumber}][birthday(1i)]" class="form-select mx-1 is-valid date required">
      <option value="2009">2009</option>
      <option value="2010">2010</option>
      <option value="2011">2011</option>
      <option value="2012">2012</option>
      <option value="2013">2013</option>
      <option value="2014" selected="selected">2014</option>
      <option value="2015">2015</option>
      <option value="2016">2016</option>
      <option value="2017">2017</option>
      <option value="2018">2018</option>
      <option value="2019">2019</option>
      </select>
      <select id="user_children_attributes_${childNumber}_birthday_2i" name="user[children_attributes][${childNumber}][birthday(2i)]" class="form-select mx-1 is-valid date required">
      <option value="1">January</option>
      <option value="2">February</option>
      <option value="3">March</option>
      <option value="4">April</option>
      <option value="5">May</option>
      <option value="6">June</option>
      <option value="7">July</option>
      <option value="8">August</option>
      <option value="9" selected="selected">September</option>
      <option value="10">October</option>
      <option value="11">November</option>
      <option value="12">December</option>
      </select>
      <select id="user_children_attributes_${childNumber}_birthday_3i" name="user[children_attributes][${childNumber}][birthday(3i)]" class="form-select mx-1 is-valid date required">
      <option value="1">1</option>
      <option value="2">2</option>
      <option value="3">3</option>
      <option value="4">4</option>
      <option value="5">5</option>
      <option value="6">6</option>
      <option value="7" selected="selected">7</option>
      <option value="8">8</option>
      <option value="9">9</option>
      <option value="10">10</option>
      <option value="11">11</option>
      <option value="12">12</option>
      <option value="13">13</option>
      <option value="14">14</option>
      <option value="15">15</option>
      <option value="16">16</option>
      <option value="17">17</option>
      <option value="18">18</option>
      <option value="19">19</option>
      <option value="20">20</option>
      <option value="21">21</option>
      <option value="22">22</option>
      <option value="23">23</option>
      <option value="24">24</option>
      <option value="25">25</option>
      <option value="26">26</option>
      <option value="27">27</option>
      <option value="28">28</option>
      <option value="29">29</option>
      <option value="30">30</option>
      <option value="31">31</option>
      </select>
      </div></div>
    `
  }
}
