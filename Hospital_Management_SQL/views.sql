#List all appointments for a doctor
CREATE VIEW DoctorwiseAppointments AS
SELECT p.first_name as Patient_FirstName, p.last_name as Patient_LastName,
d.first_name as Doctor_FirstName, d.last_name as Doctor_LastName,
a.appointment_id, a.appointment_date, a.appointment_time, a.status 
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN patients p ON a.patient_id = p.patient_id;
SELECT * from doctorwiseappointments;

#______________________________________________________________________________

#Total billing per patient
CREATE VIEW Patient_Billing_Summary AS
SELECT p.patient_id,p.first_name as Patient_FirstName, p.last_name as Patient_LastName, SUM(b.amount)
FROM billing b
JOIN patients p On b.patient_id = p.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name;
select * from patient_billing_summary;

#______________________________________________________________________________

#Doctor Patient Stats
CREATE VIEW Doctor_Patient_Stats AS
SELECT d.doctor_id, d.first_name as Doctor_FirstName, 
d.last_name as Doctor_LastName,
COUNT(DISTINCT p.patient_id) as Total_Patients,
GROUP_CONCAT(CONCAT(p.first_name, ' ', p.last_name) SEPARATOR ', ') AS Patient_List
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN patients p ON a.patient_id = p.patient_id
GROUP BY d.doctor_id, d.first_name,d.last_name;

#______________________________________________________________________________

#Most Common Treatment Type
CREATE VIEW Most_Common_Treatment AS
SELECT treatment_type, COUNT(treatment_type) as Treatment_Count,
SUM(cost) AS Total_Cost
from treatment
GROUP BY treatment_type
ORDER BY treatment_count DESC;

#______________________________________________________________________________

#Total Billing Amount By Payment Method
CREATE VIEW Billing_By_Payment_Method AS
SELECT payment_method, COUNT(payment_method) as Total_Payments,
SUM(amount) AS Total_Amount
from billing
GROUP BY payment_method
ORDER BY total_payments DESC;

#______________________________________________________________________________

# Patients with Multiple Treatments
CREATE VIEW Patients_With_Multiple_Treatments AS
SELECT p.patient_id, p.first_name as First_Name, p.last_name AS Last_Name,
count(t.treatment_type) AS Number_of_Treatments,
GROUP_CONCAT(t.treatment_type SEPARATOR ', ') AS Treatments_List,
sum(b.amount) AS Total_Bill_Amount
from billing b
JOIN patients p on b.patient_id=p.patient_id
JOIN treatment t on b.treatment_id = t.treatment_id
GROUP BY p.patient_id, p.first_name,p.last_name
ORDER BY Number_of_Treatments DESC, Total_Bill_Amount DESC;

--______________________________________________________________________________

#Pending payments
CREATE VIEW Pending_Payments AS
SELECT CONCAT(p.first_name, ' ', p.last_name) AS Patient_Name,
SUM(b.amount) AS Total_Pending,
GROUP_CONCAT(t.treatment_type SEPARATOR ', ') AS Treatments_List
FROM Billing b
JOIN Patients p ON b.patient_id = p.patient_id
JOIN Treatment t ON b.treatment_id = t.treatment_id
WHERE b.payment_status = 'Pending'
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY Total_Pending DESC;

--______________________________________________________________________________

#Total billing and pending payments by insurance provider
CREATE VIEW Insurance_Billing_Summary AS
SELECT 
    p.insurance_provider,
    COUNT(b.bill_id) AS Total_Bills,
    SUM(b.amount) AS Total_Billing,
    SUM(CASE WHEN b.payment_status = 'Pending' THEN b.amount ELSE 0 END) AS Pending_Amount,
    GROUP_CONCAT(DISTINCT t.treatment_type SEPARATOR ', ') AS Treatments_Covered
FROM Billing b
JOIN Patients p ON b.patient_id = p.patient_id
JOIN Treatment t ON b.treatment_id = t.treatment_id
WHERE p.insurance_provider IS NOT NULL
GROUP BY p.insurance_provider
ORDER BY Total_Billing DESC;
