package main

import (
	"math/rand"
	"net/http"
	"os"
	"strconv"
	"time"
	// "database/sql"

	_ "github.com/lib/pq"

	log "github.com/Sirupsen/logrus"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	go tick()
	// go db()
	startMetrics()
}

var (
	generatorCounter = prometheus.NewCounter(prometheus.CounterOpts{
		Namespace: "dksto",
		Name:      "generator_count",
		Help:      "Number of generated messages.",
		// ConstLabels:
	})
)

func init() {
	// Seed for rand
	rand.Seed(time.Now().UTC().UnixNano())
	// Metrics have to be registered to be exposed:
	prometheus.MustRegister(generatorCounter)
}

func tick() {
	rate := rand.Intn(10) + 5 // 5-15
	ticker := time.NewTicker(time.Millisecond * 1000)
	for _ = range ticker.C {
		generatorCounter.Add(float64(rate))

		for i := 0; i < 10; i++ {
			insert()
		}
		sofar()
	}
}

// Message is the model we are storing
type Message struct {
	gorm.Model
	Stamp   string
	Message string
}

// RFC3339Milli is the format for our timestamps
const RFC3339Milli = "2006-01-02T15:04:05.999Z07:00"

// bad global var!
var db *gorm.DB

func openDB() {
	if db != nil {
		return
	}
	var err error
	// db, err := gorm.Open("sqlite3", "test.db")
	// db, err := gorm.Open("postgres", "host=localhost user=gorm dbname=gorm sslmode=disable password=mypassword")

	connectionString := getenv("DB_CONNECT", "host=localhost dbname=dksto sslmode=disable user=dkstouser password=dkstoseKret")
	db, err = gorm.Open("postgres", connectionString)
	if err != nil {
		log.Fatal("failed to connect database", err)
	}
	// defer db.Close()

	// Migrate the schema
	db.AutoMigrate(&Message{})

}
func sofar() {
	openDB()

	// Scan
	type Result struct {
		Stamp string
		Count int
	}

	var result Result
	err := db.Raw("SELECT max(stamp) as stamp, count(*) as count FROM messages").Scan(&result).Error
	if err != nil {
		log.Fatal("failed to get sofar...", err)
	}

	log.WithFields(log.Fields{
		"count": result.Count,
		"stamp": result.Stamp,
		// "message": message.Message,
	}).Info("sofar")
}

var counter = 0

func insert() {
	openDB()

	// Create
	counter++
	message := &Message{
		Stamp:   time.Now().Format(RFC3339Milli),
		Message: "Message #" + strconv.Itoa(counter),
	}
	err := db.Create(message).Error
	if err != nil {
		log.Fatal("failed to insert...", err)
	}

	log.WithFields(log.Fields{
		"stamp":   message.Stamp,
		"message": message.Message,
	}).Info("insert")

	// Read
	// var message Message
	// db.First(&message, 1) // find message with id 1
	// db.First(&message, "code = ?", "L1212") // find message with code l1212
	// db.Last(&message)

	// var count int
	// db.Model(&Message{}).Count(&count)
}

func getenv(key, fallback string) string {
	value := os.Getenv(key)
	if len(value) == 0 {
		return fallback
	}
	return value
}

// Start the generator
func startMetrics() {

	// The Handler function provides a default handler to expose metrics
	// via an HTTP server. "/metrics" is the usual endpoint for that.
	http.Handle("/metrics", promhttp.Handler())
	port := getenv("PORT", "8080")
	log.WithFields(log.Fields{
		"port": port,
	}).Info("generator starting")
	log.Fatal(http.ListenAndServe(":"+port, nil))

}
