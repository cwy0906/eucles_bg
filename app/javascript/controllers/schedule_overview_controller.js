import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values  = {queryUrl: String, scheduleCardTemplate: String, scheduleModalTemplate: String}
  static targets = ["results"]

  connect() {
    this.scheduleCardTemplateValue = ``; 
    this.cheduleModalTemplateValue = ``;
    this.show()
  }

  show() {
    fetch(this.queryUrlValue, {headers:{"Accept":"application/json"}}).then(response => response.json()).then(data => {
   
      let schedule_cards_html = ``;
      data.forEach(obj => {
        schedule_cards_html = schedule_cards_html + this.getScheduleCardTemplate(obj) + this.getScheduleModalTemplate(obj);
      })
      this.resultsTarget.innerHTML = schedule_cards_html

    })
  }

  getScheduleCardTemplate(schedule_obj){
    let schedule_status = "" 
    if (schedule_obj["status"] === "pending") {
      schedule_status = "checked"
    }
    
    return `
      <div class="card">
      <h5 class="card-header">
        <strong>Bank name:</strong>&nbsp;<em>${schedule_obj["bank_name"]}</em>&nbsp;&nbsp;&nbsp;<strong>Currency:</strong>&nbsp;<em>${schedule_obj["currency"]}</em>&nbsp;&nbsp;&nbsp;<strong>Status:</strong>&nbsp;<em>${schedule_obj["status"]}</em>
      </h5>
      <div class="card-body d-flex">
        <div class="flex-fill">
            <div class="d-flex gap-2 m-1">
                <span class="badge bg-primary rounded-pill fs-5 fw-bold py-4 px-2">Current: ${schedule_obj["rate_at_setting"]}</span>
                <span class="badge bg-info rounded-pill fs-5 fw-bold py-4 px-2">Threshold:${schedule_obj["target_rate"]}</span>
            </div>
            <br>
            <div class="d-flex gap-2">
              <a href="#" class="btn btn-success m-1" data-bs-toggle="modal" data-bs-target="#editorModal_${schedule_obj["id"]}">Adjust alert setting</a>
              <div class="form-check form-switch m-1">
                <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault" ${schedule_status}>
                <label class="form-check-label" for="flexSwitchCheckDefault">switch</label>
              </div>
            </div>
        </div>
        <div class="flex-fill border">
          <div class="m-4">
            <h5 class="card-title">Message</h5>
            <p class="card-text">${schedule_obj["message_content"]}</p>
          </div>
        </div>
      </div>
        <div class="card-footer text-muted">
        Last Updated Date:${schedule_obj["updated_at"]}
        </div>          
      </div>
      <br>`;
  }

  getScheduleModalTemplate(schedule_obj){
    return `
    <div class="modal fade" id="editorModal_${schedule_obj["id"]}" tabindex="-1" aria-labelledby="editorModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header bg-info">
            <h5 class="modal-title" id="editorModalLabel">Adjust Preview</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body d-flex">
            <div class="flex-fill">
              <h6 class="card-title">Before Adjust</h6>
              <p class="card-text">
                <div class="mb-3 m-2">
                <textarea class="form-control" id="longTextInput" name="longTextInput" rows="5" disabled>${schedule_obj["message_content"]}</textarea>
                </div>
                <div class="mb-3 m-2">
                  <input type="number" class="form-control" id="rangeInput" name="rangeInput" value=${schedule_obj["target_rate"]} disabled>
                </div>
              </p>
            </div>
            <div class="flex-fill">
              <h6 class="card-title">After Adjust</h6>
              <p class="card-text">
                <div class="mb-3 m-2">
                  <textarea class="form-control" id="longTextInput" name="longTextInput" rows="5"></textarea>
                </div>
                <div class="mb-3 m-2">
                  <input type="number" class="form-control" id="rangeInput" name="rangeInput" min="90" max="150" step="0.01">
                </div>
              </p>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-primary">Confirm</button>
          </div>
        </div>
      </div>
      </div>`;
  }

}
