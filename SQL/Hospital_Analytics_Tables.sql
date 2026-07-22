CREATE DATABASE hospital_analytics;
USE hospital_analytics;

USE hospital_analytics;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    ExperienceYears INT,
    Salary DECIMAL(10,2),
    Shift VARCHAR(20),

    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(100) NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    City VARCHAR(100),
    BloodGroup VARCHAR(5),
    MaritalStatus VARCHAR(20),
    InsuranceType VARCHAR(50)
);

CREATE TABLE Medicines (
    MedicineID INT PRIMARY KEY,
    MedicineName VARCHAR(100),
    Manufacturer VARCHAR(100),
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    Status1 VARCHAR(20),
    Diagnosis VARCHAR(100),

    FOREIGN KEY (PatientID)
    REFERENCES Patients(PatientID),

    FOREIGN KEY (DoctorID)
    REFERENCES Doctors(DoctorID)
);

CREATE TABLE Treatments (
    TreatmentID INT PRIMARY KEY,
    AppointmentID INT,
    TreatmentName VARCHAR(100),
    TreatmentCost DECIMAL(10,2),

    FOREIGN KEY (AppointmentID)
    REFERENCES Appointments(AppointmentID)
);

CREATE TABLE Billing (
    BillID INT PRIMARY KEY,
    AppointmentID INT,
    BillAmount DECIMAL(10,2),
    PaymentMethod VARCHAR(30),
    PaymentStatus VARCHAR(20),

    FOREIGN KEY (AppointmentID)
    REFERENCES Appointments(AppointmentID)
);

CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY,
    AppointmentID INT,
    MedicineID INT,
    Dosage VARCHAR(50),
    DurationDays INT,

    FOREIGN KEY (AppointmentID)
    REFERENCES Appointments(AppointmentID),

    FOREIGN KEY (MedicineID)
    REFERENCES Medicines(MedicineID)
);














