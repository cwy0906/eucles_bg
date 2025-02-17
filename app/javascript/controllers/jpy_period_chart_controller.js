import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values  = {url: String}
  static targets = ["periodInfo","chartContainer","updateBtn6m","updateBtn3m","updateBtn1w"]

  connect() {
    this.load6mChart()
  }

  load6mChart() {
    fetch(this.urlValue+"?period=6m", {headers:{"Accept":"application/json"}}).then(response => response.json()).then(data => {
      this.periodInfoTarget.textContent = data["jpy_query_date"]["start"]+" ~ "+data["jpy_query_date"]["end"]

      let mean_value = data["recent_period_jpy_rate_result"]["mean_rate"]
      let options    = {id:"jpy_period_line_chart",library: {plugins: {annotation: {annotations:[{type: 'line',yMin: mean_value ,yMax: mean_value ,borderColor:'red',borderDash: [6, 6],borderDashOffset: 0,borderWidth:1,label:{backgroundColor: 'rgba(244, 152, 152, 0.5)',borderWidth: 0,content: "mean("+String(mean_value)+")",position: '0%',yAdjust: -15,display: true,font: {size: 10},},}]}}},zeros:true,precision:4,xtitle:'Date',ytitle:'NTD/JPY', min:null, max: null};

      new Chartkick.LineChart(this.chartContainerTarget, [
        { name: "JPY - cash selling", data: data["recent_period_jpy_rate_result"]["historical_rate"] }
      ], options);

      this.updateBtn6mTarget.className = "btn btn-secondary active";
      this.updateBtn3mTarget.className = "btn btn-primary";
      this.updateBtn1wTarget.className = "btn btn-primary";
    })
  }

  load3mChart(){
    fetch(this.urlValue+"?period=3m", {headers:{"Accept":"application/json"}}).then(response => response.json()).then(data => {
      this.periodInfoTarget.textContent = data["jpy_query_date"]["start"]+" ~ "+data["jpy_query_date"]["end"]

      let mean_value = data["recent_period_jpy_rate_result"]["mean_rate"]
      let options    = {id:"jpy_period_line_chart",library: {plugins: {annotation: {annotations:[{type: 'line',yMin: mean_value ,yMax: mean_value ,borderColor:'red',borderDash: [6, 6],borderDashOffset: 0,borderWidth:1,label:{backgroundColor: 'rgba(244, 152, 152, 0.5)',borderWidth: 0,content: "mean("+String(mean_value)+")",position: '0%',yAdjust: -15,display: true,font: {size: 10},},}]}}},zeros:true,precision:4,xtitle:'Date',ytitle:'NTD/JPY', min:null, max: null};

      new Chartkick.LineChart(this.chartContainerTarget, [
        { name: "JPY - cash selling", data: data["recent_period_jpy_rate_result"]["historical_rate"] }
      ], options);

      this.updateBtn6mTarget.className = "btn btn-primary";
      this.updateBtn3mTarget.className = "btn btn-secondary active";
      this.updateBtn1wTarget.className = "btn btn-primary";
    })
  }

  load1wChart(){
    fetch(this.urlValue+"?period=1w", {headers:{"Accept":"application/json"}}).then(response => response.json()).then(data => {
      this.periodInfoTarget.textContent = data["jpy_query_date"]["start"]+" ~ "+data["jpy_query_date"]["end"]

      let mean_value = data["recent_period_jpy_rate_result"]["mean_rate"]
      let options    = {id:"jpy_period_line_chart",library: {plugins: {annotation: {annotations:[{type: 'line',yMin: mean_value ,yMax: mean_value ,borderColor:'red',borderDash: [6, 6],borderDashOffset: 0,borderWidth:1,label:{backgroundColor: 'rgba(244, 152, 152, 0.5)',borderWidth: 0,content: "mean("+String(mean_value)+")",position: '0%',yAdjust: -15,display: true,font: {size: 10},},}]}}},zeros:true,precision:4,xtitle:'Date',ytitle:'NTD/JPY', min:null, max: null};

      new Chartkick.LineChart(this.chartContainerTarget, [
        { name: "JPY - cash selling", data: data["recent_period_jpy_rate_result"]["historical_rate"] }
      ], options);

      this.updateBtn6mTarget.className = "btn btn-primary";
      this.updateBtn3mTarget.className = "btn btn-primary";
      this.updateBtn1wTarget.className = "btn btn-secondary active";
    })
  }

}
